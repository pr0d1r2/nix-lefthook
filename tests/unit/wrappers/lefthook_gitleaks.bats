#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook-gitleaks is available on PATH" {
    run command -v lefthook-gitleaks
    assert_success
}

@test "lefthook-gitleaks is executable" {
    WRAPPER="$(command -v lefthook-gitleaks)"
    assert [ -x "$WRAPPER" ]
}

@test "lefthook-gitleaks is defined in nix/lefthook-wrappers-for.nix" {
    run grep 'lefthook-gitleaks' nix/lefthook-wrappers-for.nix
    assert_success
}
