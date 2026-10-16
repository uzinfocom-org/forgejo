#!/usr/bin/env bash
# Read config.toml and run the test suite with integration tests enabled.
# Run gen-config.sh first if config.toml is missing.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$ROOT/config.toml"

if [[ ! -f "$CONFIG" ]]; then
  echo "error: config.toml not found — run:  just gen-config" >&2
  exit 1
fi

export FORGEJO_URL=$(yq '.forgejo.url' "$CONFIG")
export FORGEJO_TOKEN=$(yq '.forgejo.token' "$CONFIG")
export FORGEJO_OWNER=$(yq '.test.owner' "$CONFIG")
export FORGEJO_REPO=$(yq '.test.repo' "$CONFIG")

# Optional — org tests are skipped when this is empty.
org=$(yq '.test.org // ""' "$CONFIG")
[[ -n "$org" ]] && export FORGEJO_ORG="$org"

exec cabal test forgejo-test "$@"
