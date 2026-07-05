#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "CI uses nix-lefthook-ci-action pinned to a full commit SHA" {
    run grep -E 'pr0d1r2/nix-lefthook-ci-action@[0-9a-f]{40}' .github/workflows/ci.yml
    assert_success
}

@test "CI pins both jobs to the same nix-lefthook-ci-action commit" {
    run grep -c 'pr0d1r2/nix-lefthook-ci-action@ce9a118b05e90e186dba48a82067adeed185f7d4' .github/workflows/ci.yml
    assert_success
    assert_output "2"
}
