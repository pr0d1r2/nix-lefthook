#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-bats-unit is available on PATH" {
    run command -v lefthook-bats-unit
    assert_success
}

@test "lefthook-bats-unit is executable" {
    WRAPPER="$(command -v lefthook-bats-unit)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-bats-unit is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-bats-unit' nix/lefthook-wrappers-for.nix
    assert_success
}
