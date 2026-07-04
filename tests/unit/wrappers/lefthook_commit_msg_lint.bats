#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-commit-msg-lint is available on PATH" {
    run command -v lefthook-commit-msg-lint
    assert_success
}

@test "lefthook-commit-msg-lint is executable" {
    WRAPPER="$(command -v lefthook-commit-msg-lint)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-commit-msg-lint is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-commit-msg-lint' nix/lefthook-wrappers-for.nix
    assert_success
}
