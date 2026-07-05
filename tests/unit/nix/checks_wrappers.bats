#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "nix/checks-wrappers.sh exists" {
    assert [ -f nix/checks-wrappers.sh ]
}

@test "nix/checks-wrappers.sh reads WRAPPER_NAMES" {
    run grep 'WRAPPER_NAMES' nix/checks-wrappers.sh
    assert_success
}

@test "nix/checks-wrappers.sh checks executability" {
    run grep -E '\-x' nix/checks-wrappers.sh
    assert_success
}

@test "nix/checks-wrappers.sh runs bash -n syntax check" {
    run grep 'bash -n' nix/checks-wrappers.sh
    assert_success
}

@test "nix/checks-wrappers.sh creates output directory" {
    # shellcheck disable=SC2016
    run grep 'mkdir.*\$out' nix/checks-wrappers.sh
    assert_success
}

@test "nix/checks-wrappers.sh has no functions" {
    run grep -cE '^\s*[a-zA-Z_]+\s*\(\)\s*\{' nix/checks-wrappers.sh
    assert_failure
}

@test "nix/checks-wrappers.sh has shellcheck directive" {
    run grep '# shellcheck' nix/checks-wrappers.sh
    assert_success
}

@test ".envrc watches nix/checks-wrappers.sh" {
    run grep 'watch_file nix/checks-wrappers.sh' .envrc
    assert_success
}
