#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-unit-coverage is available on PATH" {
    run command -v lefthook-unit-coverage
    assert_success
}

@test "lefthook-unit-coverage is executable" {
    WRAPPER="$(command -v lefthook-unit-coverage)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-unit-coverage is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-unit-coverage' nix/lefthook-wrappers-for.nix
    assert_success
}
