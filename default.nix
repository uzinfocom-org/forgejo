{
  dream2nix,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    dream2nix.modules.dream2nix.WIP-haskell-cabal
  ];

  name = "forgejo";
  version = "0.1.0.0";

  deps = {nixpkgs, ...}: {
    haskell-compiler = nixpkgs.haskell.compiler.ghc912;
    inherit
      (nixpkgs)
      bzip2
      gnupg
      libpq
      libzip
      pkg-config
      zlib
      git
      ;
  };

  mkDerivation.src = lib.cleanSourceWith {
    src = lib.cleanSource ./.;
    filter = name: type: let
      baseName = baseNameOf (toString name);
    in
      !(lib.hasSuffix ".nix" baseName);
  };

  mkDerivation.buildInputs =
    (with config.deps; [
      zlib
      bzip2
      bzip2.dev
      libzip
      libpq
    ])
    ++ (with pkgs; [
      git
    ]);

  mkDerivation.nativeBuildInputs = [
    config.deps.pkg-config
  ];
}
