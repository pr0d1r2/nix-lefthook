#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-bats-parse is available on PATH" {
    run command -v lefthook-bats-parse
    assert_success
}

@test "lefthook-bats-parse is executable" {
    WRAPPER="$(command -v lefthook-bats-parse)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-bats-parse is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-bats-parse' nix/lefthook-wrappers-for.nix
    assert_success
}
