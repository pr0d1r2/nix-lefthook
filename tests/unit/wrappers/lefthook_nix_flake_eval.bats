#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-nix-flake-eval is available on PATH" {
    run command -v lefthook-nix-flake-eval
    assert_success
}

@test "lefthook-nix-flake-eval is executable" {
    WRAPPER="$(command -v lefthook-nix-flake-eval)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-nix-flake-eval is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-nix-flake-eval' nix/lefthook-wrappers-for.nix
    assert_success
}
