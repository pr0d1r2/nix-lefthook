#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-nixfmt is available on PATH" {
    run command -v lefthook-nixfmt
    assert_success
}

@test "lefthook-nixfmt is executable" {
    WRAPPER="$(command -v lefthook-nixfmt)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-nixfmt is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-nixfmt' nix/lefthook-wrappers-for.nix
    assert_success
}
