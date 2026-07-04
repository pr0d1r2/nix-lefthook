#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-narrow-language-suggest is available on PATH" {
    run command -v lefthook-narrow-language-suggest
    assert_success
}

@test "lefthook-narrow-language-suggest is executable" {
    WRAPPER="$(command -v lefthook-narrow-language-suggest)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-narrow-language-suggest is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-narrow-language-suggest' nix/lefthook-wrappers-for.nix
    assert_success
}
