#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-narrow-language is available on PATH" {
    run command -v lefthook-narrow-language
    assert_success
}

@test "lefthook-narrow-language is executable" {
    WRAPPER="$(command -v lefthook-narrow-language)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-narrow-language is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-narrow-language' nix/lefthook-wrappers-for.nix
    assert_success
}
