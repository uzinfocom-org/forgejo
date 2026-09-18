#!/usr/bin/env bash
# Decrypt .sops/secrets.yaml and write config.toml to the project root.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS="$ROOT/.sops/secrets.yaml"
OUTPUT="$ROOT/config.toml"

if [[ ! -f "$SECRETS" ]]; then
  echo "error: $SECRETS not found" >&2
  echo "Create it with:  just init-secrets  then  just edit-secrets" >&2
  exit 1
fi

# Decrypt once so sops is only invoked a single time.
decrypted=$(sops --decrypt "$SECRETS")

forgejo_url=$(echo "$decrypted"   | yq '.forgejo.url')
forgejo_token=$(echo "$decrypted" | yq '.forgejo.token')
test_owner=$(echo "$decrypted"    | yq '.test.owner')
test_repo=$(echo "$decrypted"     | yq '.test.repo')
test_org=$(echo "$decrypted"      | yq '.test.org // ""')

cat > "$OUTPUT" <<EOF
[forgejo]
url = "$forgejo_url"
token = "$forgejo_token"

[test]
owner = "$test_owner"
repo = "$test_repo"
org = "$test_org"
EOF

echo "Generated $OUTPUT"
