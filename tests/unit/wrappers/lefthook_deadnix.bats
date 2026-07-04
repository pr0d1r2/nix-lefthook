#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-deadnix is available on PATH" {
    run command -v lefthook-deadnix
    assert_success
}

@test "lefthook-deadnix is executable" {
    WRAPPER="$(command -v lefthook-deadnix)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-deadnix is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-deadnix' nix/lefthook-wrappers-for.nix
    assert_success
}
