#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-unicode-lint is available on PATH" {
    run command -v lefthook-unicode-lint
    assert_success
}

@test "lefthook-unicode-lint is executable" {
    WRAPPER="$(command -v lefthook-unicode-lint)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-unicode-lint is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-unicode-lint' nix/lefthook-wrappers-for.nix
    assert_success
}
