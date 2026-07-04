#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-typos is available on PATH" {
    run command -v lefthook-typos
    assert_success
}

@test "lefthook-typos is executable" {
    WRAPPER="$(command -v lefthook-typos)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-typos is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-typos' nix/lefthook-wrappers-for.nix
    assert_success
}
