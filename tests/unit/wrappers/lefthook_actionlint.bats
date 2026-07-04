#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-actionlint is available on PATH" {
    run command -v lefthook-actionlint
    assert_success
}

@test "lefthook-actionlint is executable" {
    WRAPPER="$(command -v lefthook-actionlint)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-actionlint is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-actionlint' nix/lefthook-wrappers-for.nix
    assert_success
}
