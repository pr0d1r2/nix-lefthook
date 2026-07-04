#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-linter-coverage-full is available on PATH" {
    run command -v lefthook-linter-coverage-full
    assert_success
}

@test "lefthook-linter-coverage-full is executable" {
    WRAPPER="$(command -v lefthook-linter-coverage-full)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-linter-coverage-full is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-linter-coverage-full' nix/lefthook-wrappers-for.nix
    assert_success
}
