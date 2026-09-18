# Run unit tests (no secrets needed)
test:
    cabal test forgejo-test

# Run integration tests against a live Forgejo instance (requires config.toml)
test-integration:
    bash scripts/run-tests.sh

# Decrypt .sops/secrets.yaml and generate config.toml
gen-config:
    bash scripts/gen-config.sh

# Open the encrypted secrets file in $EDITOR for editing
edit-secrets:
    sops .sops/secrets.yaml

# Create secrets.yaml by encrypting the example template (run once per setup)
init-secrets:
    cp .sops/secrets.example.yaml .sops/secrets.yaml
    sops --encrypt --in-place .sops/secrets.yaml
