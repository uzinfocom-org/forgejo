#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$ROOT/config.toml"

if [[ -z "${FG_URL:-}" ]]; then
  if [[ ! -f "$CONFIG" ]]; then
    echo "error: no credentials — export FG_URL and FG_TOKEN (optionally FG_ORG)," >&2
    echo "       or create config.toml:  cp config.example.toml config.toml" >&2
    exit 1
  fi

  FG_URL=$(yq '.forgejo.url' "$CONFIG")
  FG_TOKEN=$(yq '.forgejo.token' "$CONFIG")
  export FG_URL FG_TOKEN

  org=$(yq '.test.org // ""' "$CONFIG")
  [[ -n "$org" ]] && export FG_ORG="$org"
fi

exec cabal test forgejo-test --test-show-details=direct "$@"
