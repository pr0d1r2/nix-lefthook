#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-editorconfig-checker is available on PATH" {
    run command -v lefthook-editorconfig-checker
    assert_success
}

@test "lefthook-editorconfig-checker is executable" {
    WRAPPER="$(command -v lefthook-editorconfig-checker)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-editorconfig-checker is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-editorconfig-checker' nix/lefthook-wrappers-for.nix
    assert_success
}
