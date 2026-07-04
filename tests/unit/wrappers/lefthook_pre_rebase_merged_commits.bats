#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-pre-rebase-merged-commits is available on PATH" {
    run command -v lefthook-pre-rebase-merged-commits
    assert_success
}

@test "lefthook-pre-rebase-merged-commits is executable" {
    WRAPPER="$(command -v lefthook-pre-rebase-merged-commits)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-pre-rebase-merged-commits is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-pre-rebase-merged-commits' nix/lefthook-wrappers-for.nix
    assert_success
}
