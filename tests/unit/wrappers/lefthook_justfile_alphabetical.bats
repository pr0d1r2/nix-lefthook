#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-justfile-alphabetical is available on PATH" {
    run command -v lefthook-justfile-alphabetical
    assert_success
}

@test "lefthook-justfile-alphabetical is executable" {
    WRAPPER="$(command -v lefthook-justfile-alphabetical)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-justfile-alphabetical is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-justfile-alphabetical' nix/lefthook-wrappers-for.nix
    assert_success
}
