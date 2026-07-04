#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-narrow-language-add is available on PATH" {
    run command -v lefthook-narrow-language-add
    assert_success
}

@test "lefthook-narrow-language-add is executable" {
    WRAPPER="$(command -v lefthook-narrow-language-add)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-narrow-language-add is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-narrow-language-add' nix/lefthook-wrappers-for.nix
    assert_success
}
