#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-narrow-language-compact is available on PATH" {
    run command -v lefthook-narrow-language-compact
    assert_success
}

@test "lefthook-narrow-language-compact is executable" {
    WRAPPER="$(command -v lefthook-narrow-language-compact)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-narrow-language-compact is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-narrow-language-compact' nix/lefthook-wrappers-for.nix
    assert_success
}
