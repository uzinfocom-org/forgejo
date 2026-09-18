{
  description = "Forgejo bot client";
  inputs = {
    dream2nix.url = "github:lambdajon/dream2nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    git-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, dream2nix, nixpkgs, nixpkgs-unstable, systems, git-hooks
    , treefmt-nix, }:
    let
      eachSystem = f:
        nixpkgs.lib.genAttrs (import systems)
        (system: f nixpkgs.legacyPackages.${system});
      # pkgsUnstable pulled in solely for a newer fourmolu with GHC2024 support;
      # everything else still comes from the pinned nixpkgs.
      pkgsUnstable =
        eachSystem (pkgs: nixpkgs-unstable.legacyPackages.${pkgs.system});
      treefmt = {
        projectRootFile = "flake.nix";
        programs.fourmolu.enable = true;
        programs.cabal-fmt.enable = true;
        programs.nixfmt.enable = true;
      };
      treefmtEval = eachSystem (pkgs:
        treefmt-nix.lib.evalModule pkgs (treefmt // {
          programs.fourmolu.package =
            pkgsUnstable.${pkgs.system}.haskell.packages."ghc912".fourmolu;
        }));
    in {
      formatter =
        eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      packages = eachSystem (pkgs: {
        default = dream2nix.lib.evalModules {
          packageSets.nixpkgs = pkgs;
          modules = [
            ./default.nix
            {
              paths.projectRoot = ./.;
              paths.projectRootFile = "flake.nix";
              paths.package = ./.;
            }
          ];
        };
      });
      checks = eachSystem (pkgs: {
        pre-commit = git-hooks.lib.${pkgs.system}.run {
          src = ./.;
          hooks = {
            treefmt = {
              enable = true;
              package = treefmtEval.${pkgs.system}.config.build.wrapper;
            };
          };
        };
      });
      devShells = eachSystem (pkgs:
        let
          hlib = pkgs.haskell.lib;
          hp = pkgs.haskell.packages."ghc912".override {
            overrides = self: super: {
              brick = hlib.dontCheck (hlib.doJailbreak super.brick);
            };
          };
        in {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.cabal-install
              hp.ghc
              hp.haskell-language-server
              pkgsUnstable.${pkgs.system}.haskell.packages."ghc912".fourmolu
              hp.hlint
              hp.ghcid
              hp.implicit-hie
              pkgs.haskellPackages.cabal-fmt
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
              treefmtEval.${pkgs.system}.config.build.wrapper
              pkgs.nixfmt
              pkgs.jq
              pkgs.just
              pkgs.sops
              pkgs.age
              pkgs.yq-go
            ] ++ self.checks.${pkgs.system}.pre-commit.enabledPackages;
            shellHook = ''
              echo "Welcome to Forgejo dev shell"
              ${self.checks.${pkgs.system}.pre-commit.shellHook}
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.postgresql}/lib
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.libzip}/lib
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.bzip2}/lib
              export LIBRARY_PATH=$LIBRARY_PATH:${pkgs.bzip2}/lib
              export NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.bzip2}/lib"
            '';
            NIX_CONFIG = "extra-experimental-features = nix-command flakes";
          };
        });
      apps = eachSystem (pkgs:
        let refresh = self.packages.${pkgs.system}.default.config.lock.refresh;
        in {
          update-lock = {
            type = "app";
            program = "${pkgs.writeShellScript "update-lock" ''
              export PATH="${pkgs.git}/bin:${pkgs.cabal-install}/bin:$PATH"
              exec ${nixpkgs.lib.getExe refresh}
            ''}";
          };
        });
    };
}
