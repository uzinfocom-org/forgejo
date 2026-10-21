#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$ROOT/config.toml"

if [[ -z "${FORGEJO_URL:-}" ]]; then
  if [[ ! -f "$CONFIG" ]]; then
    echo "error: no credentials — export FORGEJO_URL and FORGEJO_TOKEN (optionally FORGEJO_ORG)," >&2
    echo "       or create config.toml:  cp config.example.toml config.toml" >&2
    exit 1
  fi

  FORGEJO_URL=$(yq '.forgejo.url' "$CONFIG")
  FORGEJO_TOKEN=$(yq '.forgejo.token' "$CONFIG")
  export FORGEJO_URL FORGEJO_TOKEN

  org=$(yq '.test.org // ""' "$CONFIG")
  [[ -n "$org" ]] && export FORGEJO_ORG="$org"
fi

exec cabal test forgejo-test --test-show-details=direct "$@"
