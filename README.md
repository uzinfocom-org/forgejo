# forgejo

📖 Easy to use library for building Forgejo bots in Haskell.

`forgejo` is a Servant-based client for the [Forgejo](https://forgejo.org) REST API (Gitea-compatible). It wraps the API's issues, pull requests, repositories, organizations, commit statuses, and webhooks in typed Haskell, so bots and automation tools can talk to a Forgejo instance without hand-rolling HTTP calls and JSON decoding.

## Features

- Typed client functions for the core Forgejo/Gitea API surface:
  - Issues and issue comments
  - Pull requests (including merge, review, and status operations)
  - Repositories, branches, and commits
  - Organizations and organization membership
  - Commit statuses
- Webhook payload types and parsing (`Forgejo.Webhook`) for handling incoming events
- Built on `servant-client`, so requests are described as types and checked at compile time
- No dependency on `libgit2`/`gitlib` — this library only talks to the Forgejo *API*; local git operations (clone, cherry-pick, push) are left to the caller

## Installation

Add `forgejo` to your project's dependencies. Since it isn't published on Hackage yet, pull it in as a source dependency.

**cabal.project**

```cabal
source-repository-package
  type: git
  location: https://github.com/uzinfocom-org/forgejo.git
  tag: main
```

**Nix flake**

If your project already uses a flake, you can bring in `forgejo` as an input and reference it from your Haskell package set overrides, or use `nix develop` from this repo directly while iterating on both projects together.

## Quickstart

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Forgejo.App
import Forgejo.Methods.PullRequest

main :: IO ()
main = do
  -- configure a client pointed at your Forgejo instance,
  -- authenticated with a personal/bot access token
  env <- mkForgejoEnv "https://git.example.com" "<api-token>"

  -- call an endpoint
  result <- runForgejo env (getPullRequest "my-org" "my-repo" 42)
  print result
```

> The exact names above (`mkForgejoEnv`, `runForgejo`) are illustrative — see `src/Forgejo/App.hs` for the real entry points and `src/Forgejo/Methods/` for the full list of available calls. Happy to fill this section in precisely once you confirm the actual API — just paste `App.hs` or point me at it.

## Requirements

- GHC 9.12.x (project targets `GHC2024`)
- A running Forgejo (or Gitea-compatible) instance and an API token with the permissions your bot needs

## Development

See [CONTRIBUTING.md](./CONTRIBUTING.md) for setup instructions (including the Nix dev shell), code style, and how to submit changes.

## License

[BSD-3-Clause](./LICENSE)
