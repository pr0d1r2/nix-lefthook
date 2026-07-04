#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-nix-flake-check is available on PATH" {
    run command -v lefthook-nix-flake-check
    assert_success
}

@test "lefthook-nix-flake-check is executable" {
    WRAPPER="$(command -v lefthook-nix-flake-check)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-nix-flake-check is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-nix-flake-check' nix/lefthook-wrappers-for.nix
    assert_success
}
