#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-no-shell-functions is available on PATH" {
    run command -v lefthook-no-shell-functions
    assert_success
}

@test "lefthook-no-shell-functions is executable" {
    WRAPPER="$(command -v lefthook-no-shell-functions)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-no-shell-functions is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-no-shell-functions' nix/lefthook-wrappers-for.nix
    assert_success
}
