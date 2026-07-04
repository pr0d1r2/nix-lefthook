#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-yamllint is available on PATH" {
    run command -v lefthook-yamllint
    assert_success
}

@test "lefthook-yamllint is executable" {
    WRAPPER="$(command -v lefthook-yamllint)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-yamllint is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-yamllint' nix/lefthook-wrappers-for.nix
    assert_success
}
