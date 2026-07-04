#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-trailing-whitespace is available on PATH" {
    run command -v lefthook-trailing-whitespace
    assert_success
}

@test "lefthook-trailing-whitespace is executable" {
    WRAPPER="$(command -v lefthook-trailing-whitespace)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-trailing-whitespace is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-trailing-whitespace' nix/lefthook-wrappers-for.nix
    assert_success
}
