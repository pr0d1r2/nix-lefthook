#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-tdd-order-bats is available on PATH" {
    run command -v lefthook-tdd-order-bats
    assert_success
}

@test "lefthook-tdd-order-bats is executable" {
    WRAPPER="$(command -v lefthook-tdd-order-bats)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-tdd-order-bats is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-tdd-order-bats' nix/lefthook-wrappers-for.nix
    assert_success
}
