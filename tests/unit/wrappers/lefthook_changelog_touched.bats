#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-changelog-touched is available on PATH" {
    run command -v lefthook-changelog-touched
    assert_success
}

@test "lefthook-changelog-touched is executable" {
    WRAPPER="$(command -v lefthook-changelog-touched)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-changelog-touched is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-changelog-touched' nix/lefthook-wrappers-for.nix
    assert_success
}
