#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-file-size-check is available on PATH" {
    run command -v lefthook-file-size-check
    assert_success
}

@test "lefthook-file-size-check is executable" {
    WRAPPER="$(command -v lefthook-file-size-check)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-file-size-check is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-file-size-check' nix/lefthook-wrappers-for.nix
    assert_success
}
