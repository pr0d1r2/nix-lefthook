#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "CI uses nix-lefthook-ci-action pinned to a tagged release" {
    run grep 'pr0d1r2/nix-lefthook-ci-action@' .github/workflows/ci.yml
    assert_success
    refute_output --partial '@fc0c391'
}

@test "CI pins nix-lefthook-ci-action to v1 tag" {
    run grep -c 'pr0d1r2/nix-lefthook-ci-action@v1$' .github/workflows/ci.yml
    assert_success
    assert_output "2"
}

@test "CI does not use commit SHA for nix-lefthook-ci-action" {
    run grep -E 'nix-lefthook-ci-action@[0-9a-f]{40}' .github/workflows/ci.yml
    assert_failure
}
