#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-statix is available on PATH" {
    run command -v lefthook-statix
    assert_success
}

@test "lefthook-statix is executable" {
    WRAPPER="$(command -v lefthook-statix)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-statix is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-statix' nix/lefthook-wrappers-for.nix
    assert_success
}
