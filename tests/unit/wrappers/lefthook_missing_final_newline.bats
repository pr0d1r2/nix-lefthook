#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-missing-final-newline is available on PATH" {
    run command -v lefthook-missing-final-newline
    assert_success
}

@test "lefthook-missing-final-newline is executable" {
    WRAPPER="$(command -v lefthook-missing-final-newline)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-missing-final-newline is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-missing-final-newline' nix/lefthook-wrappers-for.nix
    assert_success
}
