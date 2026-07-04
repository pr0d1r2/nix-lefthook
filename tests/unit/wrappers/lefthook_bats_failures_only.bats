#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-bats-failures-only is available on PATH" {
    run command -v lefthook-bats-failures-only
    assert_success
}

@test "lefthook-bats-failures-only is executable" {
    WRAPPER="$(command -v lefthook-bats-failures-only)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-bats-failures-only is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-bats-failures-only' nix/lefthook-wrappers-for.nix
    assert_success
}
