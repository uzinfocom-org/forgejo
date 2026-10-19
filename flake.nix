{
  description = "Forgejo bot client";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.git-hooks.flakeModule inputs.treefmt-nix.flakeModule ];

      systems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { config, pkgs, system, ... }:
        let
          # pkgsUnstable pulled in solely for a newer fourmolu with GHC2024 support;
          # everything else still comes from the pinned nixpkgs.
          pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages.${system};

          hl = pkgs.haskell.lib;

          hp = pkgs.haskell.packages.ghc912.override {
            overrides = self: super: {
              brick = hl.dontCheck (hl.doJailbreak super.brick);
              optparse-generic =
                hl.dontCheck (hl.doJailbreak super.optparse-generic);
              servant-client =
                hl.dontCheck (hl.doJailbreak super.servant-client);
              # Regenerate with `nix run .#cabal2nix` after editing the .cabal file.
              forgejo = self.callPackage ./nix/forgejo.nix { };
            };
          };

          forgejo = hp.forgejo;

          # Fails when nix/forgejo.nix is out of date with forgejo.cabal.
          cabal2nix-fresh = pkgs.runCommand "forgejo-cabal2nix-fresh" {
            nativeBuildInputs = [ pkgs.cabal2nix ];
          } ''
            cd ${./.}/nix
            cabal2nix .. > $TMPDIR/forgejo.nix
            diff -u forgejo.nix $TMPDIR/forgejo.nix \
              || { echo "nix/forgejo.nix is stale, run: nix run .#cabal2nix"; exit 1; }
            touch $out
          '';
        in {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.fourmolu.enable = true;
            programs.fourmolu.package =
              pkgsUnstable.haskell.packages.ghc912.fourmolu;
            programs.cabal-fmt.enable = true;
            programs.nixfmt.enable = true;
            settings.global.excludes = [ "nix/forgejo.nix" ];
            # Already covered by the pre-commit check.
            flakeCheck = false;
          };

          pre-commit.settings.hooks.treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };

          packages.default = forgejo;

          checks = {
            build = forgejo;
            inherit cabal2nix-fresh;
          };

          apps.cabal2nix = {
            type = "app";
            program = "${pkgs.writeShellScript "update-cabal2nix" ''
              cd "$(${pkgs.git}/bin/git rev-parse --show-toplevel)/nix"
              ${pkgs.cabal2nix}/bin/cabal2nix .. > forgejo.nix
            ''}";
          };

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.cabal-install
              hp.ghc
              hp.haskell-language-server
              pkgsUnstable.haskell.packages.ghc912.fourmolu
              hp.hlint
              hp.ghcid
              hp.implicit-hie
              pkgs.haskellPackages.cabal-fmt
              pkgs.cabal2nix
              pkgs.pkg-config
              pkgs.zlib
              pkgs.zlib.dev
              pkgs.bzip2
              pkgs.bzip2.dev
              pkgs.libzip
              pkgs.libpq
              pkgs.libpq.dev
              pkgs.nixd
              pkgs.statix
              pkgs.deadnix
              config.treefmt.build.wrapper
              pkgs.nixfmt
              pkgs.jq
              pkgs.just
            ] ++ config.pre-commit.settings.enabledPackages;
            shellHook = ''
              echo "Welcome to Forgejo dev shell"
              ${config.pre-commit.installationScript}
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.postgresql}/lib
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.libzip}/lib
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.bzip2}/lib
              export LIBRARY_PATH=$LIBRARY_PATH:${pkgs.bzip2}/lib
              export NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.bzip2}/lib"
            '';
            NIX_CONFIG = "extra-experimental-features = nix-command flakes";
          };
        };
    };
}
