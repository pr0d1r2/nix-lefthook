#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "CI delegates to the shared guardrails workflow" {
    run grep -E 'uses: pr0d1r2/set-and-setting/\.github/workflows/guardrails\.yml@main' .github/workflows/ci.yml
    assert_success
}

@test "CI exposes the guardrails workflow as a reusable job" {
    run grep -E '^  guardrails:$' .github/workflows/ci.yml
    assert_success
}
