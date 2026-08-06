{
  description = "Forgejo bot client";

  inputs = {
    dream2nix.url = "github:lambdajon/dream2nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = {
    self,
    dream2nix,
    nixpkgs,
    git-hooks,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    eachSystem = nixpkgs.lib.genAttrs systems;
  in {
    packages = eachSystem (system: {
      default = dream2nix.lib.evalModules {
        packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
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

    checks = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;

          hooks = {
            treefmt = {
              enable = true;
              package = pkgs.treefmt;
            };
          };
        };
      }
    );

    devShells = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      hlib = pkgs.haskell.lib;
      hp = pkgs.haskell.packages."ghc912".override {
        overrides = self: super: {
          brick = hlib.dontCheck (hlib.doJailbreak super.brick);
        };
      };
    in {
      default = pkgs.mkShell {
        nativeBuildInputs =
          [
            pkgs.cabal-install
            hp.cabal-hoogle
            hp.ghc
            hp.haskell-language-server
            hp.fourmolu
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
            pkgs.treefmt
            pkgs.alejandra

            pkgs.jq
            pkgs.just
          ]
          ++ self.checks.${system}.pre-commit.enabledPackages;

        shellHook = ''
          echo "Welcome to Forgejo dev shell"

          ${self.checks.${system}.pre-commit.shellHook}

          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.postgresql}/lib
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.libzip}/lib
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.bzip2}/lib
          export LIBRARY_PATH=$LIBRARY_PATH:${pkgs.bzip2}/lib
          export NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.bzip2}/lib"
        '';

        NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      };
    });
    apps = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      refresh = self.packages.${system}.default.config.lock.refresh;
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
