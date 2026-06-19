# homebrew-mmux

Homebrew tap for [mmux](https://github.com/marvinvr/mmux) — a persistent,
per-directory terminal multiplexer for AI coding agents and dev processes.

## Install

```sh
brew install marvinvr/mmux/mmux
```

The formula builds from source; Homebrew pulls in Rust automatically as a build
dependency. `Formula/mmux.rb` is updated automatically by CI in the main repo
whenever a `vX.Y.Z` tag is pushed (see `.github/workflows/release.yml` there) —
edit it there, not here.
