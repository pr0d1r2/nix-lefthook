#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-markdownlint is available on PATH" {
    run command -v lefthook-markdownlint
    assert_success
}

@test "lefthook-markdownlint is executable" {
    WRAPPER="$(command -v lefthook-markdownlint)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-markdownlint is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-markdownlint' nix/lefthook-wrappers-for.nix
    assert_success
}
