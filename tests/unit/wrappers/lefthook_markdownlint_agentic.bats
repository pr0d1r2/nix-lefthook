#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-markdownlint-agentic is available on PATH" {
    run command -v lefthook-markdownlint-agentic
    assert_success
}

@test "lefthook-markdownlint-agentic is executable" {
    WRAPPER="$(command -v lefthook-markdownlint-agentic)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-markdownlint-agentic is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-markdownlint-agentic' nix/lefthook-wrappers-for.nix
    assert_success
}
