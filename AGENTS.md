# AGENTS.md

flixur is a monorepo:

- a Go server (`server/`)
  - its plugin system (`pluginkit/`, `plugin-example/`, `proto/`)
- a Flutter client (`flutter/`)

Everything (toolchains, builds, codegen, formatting) is managed by the nix flake.nix
Enter the dev shell via `.envrc`/direnv or `nix develop` only if needed - you should already be in the devshell environment and have access to the tools.

- Flutter client: read **flutter/AGENTS.md** first, it covers the toolchain, Dart language style, and generated code rules.
- Codegen for the whole tree: `just generate`.
- Formatting: `nix fmt`.
- Go-side docs: INFRA.md. (NOTES.md is outdated)

A LOT of code in this repo is generated, keep this in mind when editing.

Never commit/push changes to upstream. All changes should be held back for review. Never stage changes unless required by nix tooling. Do not unstage existing staged changes.
