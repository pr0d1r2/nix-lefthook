#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-narrow-language-freeze is available on PATH" {
    run command -v lefthook-narrow-language-freeze
    assert_success
}

@test "lefthook-narrow-language-freeze is executable" {
    WRAPPER="$(command -v lefthook-narrow-language-freeze)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-narrow-language-freeze is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-narrow-language-freeze' nix/lefthook-wrappers-for.nix
    assert_success
}
