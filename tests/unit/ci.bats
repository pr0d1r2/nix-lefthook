#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "CI uses nix-lefthook-ci-action pinned to a full commit SHA" {
    run grep -E 'uses: pr0d1r2/nix-lefthook-ci-action@[0-9a-f]{40}$' .github/workflows/ci.yml
    assert_success
}

@test "CI has no unpinned nix-lefthook-ci-action references" {
    run bash -c "grep -E 'uses: pr0d1r2/nix-lefthook-ci-action@' .github/workflows/ci.yml | grep -Ev '@[0-9a-f]{40}$'"
    assert_failure
}

@test "CI pins both jobs to the same nix-lefthook-ci-action commit" {
    run grep -c 'pr0d1r2/nix-lefthook-ci-action@ce9a118b05e90e186dba48a82067adeed185f7d4' .github/workflows/ci.yml
    assert_success
}

@test "CI delegates to the shared guardrails workflow" {
    run grep -E 'uses: pr0d1r2/set-and-setting/\.github/workflows/guardrails\.yml@main' .github/workflows/ci.yml
    assert_success
}

@test "CI exposes the guardrails workflow as a reusable job" {
    run grep -E '^  guardrails:$' .github/workflows/ci.yml
    assert_success
}

@test "CI declares the workflow_dispatch trigger used by the macOS job" {
    run grep -E '^  workflow_dispatch:' .github/workflows/ci.yml
    assert_success
}
