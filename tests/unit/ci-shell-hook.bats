#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
    HOOK="$BATS_TEST_DIRNAME/../../scripts/ci-shell-hook.sh"
}

@test "sets HOME to /tmp when HOME is empty" {
    run env HOME= bash -c 'source "$1"; echo "$HOME"' -- "$HOOK"
    assert_success
    assert_output "/tmp"
}

@test "sets HOME to /tmp when HOME is unset" {
    run env -u HOME bash -c 'source "$1"; echo "$HOME"' -- "$HOOK"
    assert_success
    assert_output "/tmp"
}

@test "keeps an existing HOME" {
    run env HOME=/var/empty/ci bash -c 'source "$1"; echo "$HOME"' -- "$HOOK"
    assert_success
    assert_output "/var/empty/ci"
}

@test "defaults LEFTHOOK_BATS_PARSE_TIMEOUT to 120" {
    run env -u LEFTHOOK_BATS_PARSE_TIMEOUT bash -c 'source "$1"; echo "$LEFTHOOK_BATS_PARSE_TIMEOUT"' -- "$HOOK"
    assert_success
    assert_output "120"
}

@test "keeps an existing LEFTHOOK_BATS_PARSE_TIMEOUT" {
    run env LEFTHOOK_BATS_PARSE_TIMEOUT=300 bash -c 'source "$1"; echo "$LEFTHOOK_BATS_PARSE_TIMEOUT"' -- "$HOOK"
    assert_success
    assert_output "300"
}

@test "exports LEFTHOOK_BATS_PARSE_TIMEOUT to child processes" {
    run env -u LEFTHOOK_BATS_PARSE_TIMEOUT bash -c 'source "$1"; bash -c "echo \$LEFTHOOK_BATS_PARSE_TIMEOUT"' -- "$HOOK"
    assert_success
    assert_output "120"
}

@test "the ci devShell reads its hook from scripts/ci-shell-hook.sh" {
    run grep -F 'builtins.readFile ../scripts/ci-shell-hook.sh' "$BATS_TEST_DIRNAME/../../nix/outputs.nix"
    assert_success
}
