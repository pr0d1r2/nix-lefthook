# shellcheck shell=bash
# Sourced by the ci devShell's shellHook before the setting sync.
# CI containers can start with HOME unset; Nix and lefthook need one.
if [ -z "${HOME:-}" ]; then export HOME=/tmp; fi
export LEFTHOOK_BATS_PARSE_TIMEOUT="${LEFTHOOK_BATS_PARSE_TIMEOUT:-120}"
