{ mkDerivation, aeson, base, bytestring, conduit
, conduit-combinators, containers, filepath, generic-lens, hspec
, hspec-wai, http-api-data, http-client-tls, http-media, http-types
, lens, lib, monad-logger, mtl, named, optparse-generic
, path-pieces, safe-exceptions, servant, servant-client
, servant-client-core, servant-server, sop-core, stm, text, time
, transformers, uuid, vector, wai, wai-extra, warp
}:
mkDerivation {
  pname = "forgejo";
  version = "0.1.0.0";
  src = ./..;
  libraryHaskellDepends = [
    aeson base bytestring conduit conduit-combinators containers
    filepath generic-lens http-api-data http-client-tls http-media
    http-types lens monad-logger mtl named optparse-generic path-pieces
    safe-exceptions servant servant-client servant-client-core
    servant-server sop-core stm text time transformers uuid vector wai
    wai-extra warp
  ];
  testHaskellDepends = [
    aeson base hspec hspec-wai http-api-data http-client-tls mtl
    servant servant-client servant-server text time
  ];
  homepage = "https://github.com/uzinfocom-org/forgejo";
  license = lib.licenses.bsd3;
}
