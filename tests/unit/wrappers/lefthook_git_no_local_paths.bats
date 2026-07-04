#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-git-no-local-paths is available on PATH" {
    run command -v lefthook-git-no-local-paths
    assert_success
}

@test "lefthook-git-no-local-paths is executable" {
    WRAPPER="$(command -v lefthook-git-no-local-paths)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-git-no-local-paths is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-git-no-local-paths' nix/lefthook-wrappers-for.nix
    assert_success
}
