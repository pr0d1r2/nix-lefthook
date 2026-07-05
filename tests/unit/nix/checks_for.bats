#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "nix/checks-for.nix exists" {
    assert [ -f nix/checks-for.nix ]
}

@test "nix/checks-for.nix takes lefthookWrappersFor parameter" {
    run grep 'lefthookWrappersFor' nix/checks-for.nix
    assert_success
}

@test "nix/checks-for.nix takes pkgs parameter" {
    run grep '^pkgs:$' nix/checks-for.nix
    assert_success
}

@test "nix/checks-for.nix uses runCommand" {
    run grep 'runCommand' nix/checks-for.nix
    assert_success
}

@test "nix/checks-for.nix reads checks-wrappers.sh" {
    run grep 'checks-wrappers.sh' nix/checks-for.nix
    assert_success
}

@test "nix/checks-for.nix does not contain embedded shell" {
    run grep -c 'writeShellApplication\|writeShellScriptBin\|shellHook' nix/checks-for.nix
    assert_failure
}

@test "nix/checks-for.nix does not import other nix modules" {
    run grep -c 'import ./\|import ../\|import /' nix/checks-for.nix
    assert_failure
}

@test "nix/checks-for.nix defines wrappers check" {
    run grep 'wrappers' nix/checks-for.nix
    assert_success
}

@test "nix/checks-for.nix passes WRAPPER_NAMES" {
    run grep 'WRAPPER_NAMES' nix/checks-for.nix
    assert_success
}

@test "flake.nix imports nix/checks-for.nix" {
    run grep 'import ./nix/checks-for.nix' flake.nix
    assert_success
}

@test "flake.nix defines checks output" {
    run grep 'checks' flake.nix
    assert_success
}

@test ".envrc watches nix/checks-for.nix" {
    run grep 'watch_file nix/checks-for.nix' .envrc
    assert_success
}
