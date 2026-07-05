## §D — Description

nix-lefthook is a Nix flake that provides a pinned build of [lefthook](https://github.com/evilmartians/lefthook) (v2.1.8) as a single source of truth for git hooks management across multiple repositories. It targets Nix-based development environments on Linux and macOS (arm64/amd64), ships pre-wrapped lefthook checker scripts (shellcheck, statix, deadnix, nixfmt, typos, yamllint, gitleaks, and many more) as Nix packages, and exposes a devShell that auto-installs lefthook hooks via direnv. The project is aimed at developers who want reproducible, version-locked lefthook tooling without depending on the nixpkgs release cycle.

## §V — Invariants

1. The flake must build successfully on all four supported systems: `aarch64-darwin`, `x86_64-darwin`, `x86_64-linux`, `aarch64-linux`.
2. The built `lefthook` binary must report version `2.1.8` (tested in `tests/unit/lefthook.bats`).
3. `lefthook.yml` must configure `output: [failure]` — only failures are shown (tested in `tests/unit/lefthook_yml.bats`).
4. `dev.sh` must set `BATS_LIB_PATH` and conditionally run `lefthook install` only when `.git/hooks/pre-commit` is missing (tested in `tests/unit/dev.bats`).
5. All shell scripts must pass shellcheck and shfmt.
6. All nix files must pass statix, deadnix, and nixfmt.
7. All YAML files must pass yamllint.
8. All markdown files must pass markdownlint (with MD013 and MD024 disabled).
9. All files must have a final newline, no trailing whitespace, and LF line endings (editorconfig-checker).
10. No embedded shell in nix files — shell logic lives in external `.sh` scripts.
11. No shell functions — separate scripts with inline invocations instead.
12. Every lefthook check must run in both `pre-commit` and `pre-push` hooks.
13. CI runs on both Ubuntu (always) and macOS (push/dispatch only) via GitHub Actions.
14. Lefthook remotes fetch their `lefthook-remote.yml` configs from individual `nix-lefthook-*` repos on the `main` branch.
15. Pre-commit and pre-push hooks run in parallel (`parallel: true`).

## §I — Interfaces

### Flake outputs

| Output | Description |
|--------|-------------|
| `packages.<system>.default` | Lefthook binary (v2.1.8) |
| `packages.<system>.lefthook-*` | ~30 wrapped checker scripts (e.g. `lefthook-shellcheck`, `lefthook-statix`) |
| `overlays.default` | Nixpkgs overlay adding `pkgs.lefthook` |
| `devShells.<system>.default` | Full dev shell (CI tools + gh + nodejs + shellHook) |
| `devShells.<system>.ci` | CI-only shell (linters + bats, no shellHook) |
| `checks.<system>.wrappers` | Verify all wrapper scripts are buildable and syntactically valid |

### Config files

| File | Format | Purpose |
|------|--------|---------|
| `flake.nix` | Nix | Flake definition; version, hashes, packages, devShells |
| `lefthook.yml` | YAML | Hook configuration; remotes + output settings |
| `.envrc` | Shell | Direnv integration (`use flake`) |
| `dev.sh` | Shell | Dev shell hook; sets BATS_LIB_PATH, installs lefthook |
| `.editorconfig` | INI | Editor formatting rules |
| `.markdownlint.yml` | YAML | Markdownlint config (MD013/MD024 disabled) |
| `.yamllint.yml` | YAML | Yamllint config (truthy keys unchecked, no line-length) |
| `.gitleaks.toml` | TOML | Gitleaks config (allowlists `tests/` directory) |

### Environment variables

| Variable | Source | Purpose |
|----------|--------|---------|
| `BATS_LIB_PATH` | `dev.sh` / `devShell` | Path to bats helper libraries |

### CLI usage

```bash
nix build                    # Build lefthook binary
nix develop                  # Enter dev shell
bats tests/unit/             # Run all unit tests
lefthook run pre-commit      # Manually trigger pre-commit hooks
```

## §T — Tasks

| status | id | goal |
|--------|----|------|
| `x` | T10 | Extract `lefthookFor` builder into `nix/lefthook-for.nix`, import it in `flake.nix`, add `watch_file nix/lefthook-for.nix` to `.envrc` (§V10, §B5) |
| `x` | T11 | Extract `batsWithLibsFor` builder into `nix/bats-with-libs-for.nix`, import it in `flake.nix`, add `watch_file nix/bats-with-libs-for.nix` to `.envrc` (§V10, §B5) |
| `x` | T12 | Extract `lefthookWrappersFor` function into `nix/lefthook-wrappers-for.nix`, import it in `flake.nix`, add `watch_file nix/lefthook-wrappers-for.nix` to `.envrc` (§V10, §B5, depends T10+T11) |
| `x` | T1 | Add bats tests for each wrapped `lefthook-*` script (currently only `lefthook`, `dev`, and `lefthook_yml` have tests) |
| `x` | T2 | Add `watch_file` entries to `.envrc` for `dev.sh` and nix modules per the direnv skill requirement |
| `x` | T3 | Add a `CHANGELOG.md` to track version bumps and wrapper additions |
| `x` | T4 | Extract the `lefthookFor` and `batsWithLibsFor` builders into separate nix files under `nix/` for modularity |
| `x` | T5 | Add a `nix flake check` integration that exercises wrapper scripts on all supported systems |
| `.` | T6 | Add a version-bump script that automates updating `version`, `hash`, and `vendorHash` in `flake.nix` |
| `.` | T7 | Pin the `nix-lefthook-ci-action` in CI to a tagged release rather than a commit SHA for readability |
| `.` | T8 | Add `pre-commit` and `pre-push` local command blocks to `lefthook.yml` (currently only remotes are configured) |
| `.` | T9 | Add TOML linter coverage test to verify `taplo` is exercised on `.gitleaks.toml` and `.rtk/filters.toml` |

## §B — Bugs / Known Issues

1. **`.envrc` does not watch dependent files.** The direnv skill requires `watch_file` entries for `flake.nix`, `flake.lock`, `dev.sh`, and nix modules, but `.envrc` contains only `use flake`. Environment changes require manual `direnv reload`.
2. **No local lefthook commands defined.** `lefthook.yml` only configures `remotes` and `parallel: true` for pre-commit/pre-push — all actual checks come from remote repos. If a remote is unreachable, hooks silently pass (no local fallback).
3. **Shallow test coverage.** Only 3 bats test files exist covering `dev.sh`, the built binary, and `lefthook.yml` output config. The ~30 wrapped checker scripts have no local tests.
4. **`doCheck = false` in the lefthook build.** Upstream Go tests are skipped; if a patch introduces a regression, it won't be caught at build time.
5. **flake.nix modularity.** The single `flake.nix` is 542 lines long with all wrapper definitions inline, violating the nix modularity skill's guidance to extract common parts.
6. **CI action pinned to bare commit SHA** (`fc0c391`) with no version tag comment, making it hard to audit which version is in use.
