# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed

- Documented the migration from per-hook `packages.<system>.default` inputs
  to this flake's `lefthook-<name>` packages, including the removed
  `nix-lefthook-bats-failures-only` follow.

## [2.1.8] - 2025-06-01

### Added

- Pinned lefthook binary v2.1.8 built with `buildGo126Module`
- Nix flake with support for `aarch64-darwin`, `x86_64-darwin`, `x86_64-linux`, `aarch64-linux`
- Nixpkgs overlay at `overlays.default`
- Dev shell with direnv integration and auto `lefthook install`
- CI dev shell without shell hooks for GitHub Actions
- Wrapper scripts for lefthook checks:
  - `lefthook-actionlint` — GitHub Actions workflow linter
  - `lefthook-bats-failures-only` — bats runner showing only failures
  - `lefthook-bats-parse` — bats syntax validation
  - `lefthook-bats-unit` — bats unit test runner
  - `lefthook-changelog-touched` — verify CHANGELOG.md is updated
  - `lefthook-commit-msg-lint` — commit message format checker
  - `lefthook-deadnix` — dead Nix code detector
  - `lefthook-editorconfig-checker` — editorconfig compliance
  - `lefthook-file-size-check` — large file guard
  - `lefthook-git-conflict-markers` — leftover conflict marker detector
  - `lefthook-git-no-local-paths` — prevent hardcoded local paths
  - `lefthook-gitleaks` — secret leak scanner
  - `lefthook-justfile-alphabetical` — justfile recipe ordering
  - `lefthook-justfile-no-embedded-shell` — justfile shell extraction enforcer
  - `lefthook-linter-coverage-full` — ensure all file types have linters
  - `lefthook-markdownlint-agentic` — markdown linter for agentic repos
  - `lefthook-missing-final-newline` — final newline enforcer
  - `lefthook-narrow-language` — narrow language usage checker
  - `lefthook-narrow-language-add` — narrow language dictionary additions
  - `lefthook-narrow-language-compact` — narrow language compaction
  - `lefthook-narrow-language-freeze` — narrow language freeze check
  - `lefthook-narrow-language-suggest` — narrow language suggestions
  - `lefthook-nixfmt` — Nix code formatter
  - `lefthook-nix-flake-check` — `nix flake check` runner
  - `lefthook-nix-flake-eval` — `nix flake eval` validation
  - `lefthook-nix-no-embedded-shell` — no embedded shell in Nix files
  - `lefthook-no-shell-functions` — shell function prohibition enforcer
  - `lefthook-pre-rebase-merged-commits` — prevent rebasing merged commits
  - `lefthook-shellcheck` — shell script static analysis
  - `lefthook-shfmt` — shell script formatter
  - `lefthook-statix` — Nix anti-pattern linter
  - `lefthook-taplo` — TOML linter and formatter
  - `lefthook-tdd-order-bats` — TDD test ordering enforcer
  - `lefthook-trailing-whitespace` — trailing whitespace detector
  - `lefthook-typos` — source code spell checker
  - `lefthook-unicode-lint` — unicode homoglyph detector
  - `lefthook-unit-coverage` — unit test coverage enforcer
  - `lefthook-yamllint` — YAML linter
- Remote lefthook configurations for pre-commit and pre-push hooks
- Bats unit tests for lefthook binary, dev shell, and lefthook.yml
