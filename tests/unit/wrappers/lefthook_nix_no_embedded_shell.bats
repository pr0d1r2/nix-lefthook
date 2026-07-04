#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-nix-no-embedded-shell is available on PATH" {
    run command -v lefthook-nix-no-embedded-shell
    assert_success
}

@test "lefthook-nix-no-embedded-shell is executable" {
    WRAPPER="$(command -v lefthook-nix-no-embedded-shell)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-nix-no-embedded-shell is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-nix-no-embedded-shell' nix/lefthook-wrappers-for.nix
    assert_success
}
