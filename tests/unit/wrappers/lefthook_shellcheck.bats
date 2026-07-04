#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-shellcheck is available on PATH" {
    run command -v lefthook-shellcheck
    assert_success
}

@test "lefthook-shellcheck is executable" {
    WRAPPER="$(command -v lefthook-shellcheck)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-shellcheck is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-shellcheck' nix/lefthook-wrappers-for.nix
    assert_success
}
