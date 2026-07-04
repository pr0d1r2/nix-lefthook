#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-taplo is available on PATH" {
    run command -v lefthook-taplo
    assert_success
}

@test "lefthook-taplo is executable" {
    WRAPPER="$(command -v lefthook-taplo)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-taplo is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-taplo' nix/lefthook-wrappers-for.nix
    assert_success
}
