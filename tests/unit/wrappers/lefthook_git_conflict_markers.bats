#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-git-conflict-markers is available on PATH" {
    run command -v lefthook-git-conflict-markers
    assert_success
}

@test "lefthook-git-conflict-markers is executable" {
    WRAPPER="$(command -v lefthook-git-conflict-markers)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-git-conflict-markers is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-git-conflict-markers' nix/lefthook-wrappers-for.nix
    assert_success
}
