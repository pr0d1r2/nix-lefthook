#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "nix/bats-with-libs-for.nix exists" {
    assert [ -f nix/bats-with-libs-for.nix ]
}

@test "nix/bats-with-libs-for.nix takes pkgs parameter" {
    run grep '^pkgs:$' nix/bats-with-libs-for.nix
    assert_success
}

@test "nix/bats-with-libs-for.nix uses bats.withLibraries" {
    run grep 'bats.withLibraries' nix/bats-with-libs-for.nix
    assert_success
}

@test "nix/bats-with-libs-for.nix includes bats-support" {
    run grep 'bats-support' nix/bats-with-libs-for.nix
    assert_success
}

@test "nix/bats-with-libs-for.nix includes bats-assert" {
    run grep 'bats-assert' nix/bats-with-libs-for.nix
    assert_success
}

@test "nix/bats-with-libs-for.nix includes bats-file" {
    run grep 'bats-file' nix/bats-with-libs-for.nix
    assert_success
}

@test "nix/bats-with-libs-for.nix does not contain shell logic" {
    run grep -c 'writeShellApplication\|writeShellScriptBin\|shellHook' nix/bats-with-libs-for.nix
    assert_failure
}

@test "flake.nix imports nix/bats-with-libs-for.nix" {
    run grep 'import ./nix/bats-with-libs-for.nix' flake.nix
    assert_success
}

@test ".envrc watches nix/bats-with-libs-for.nix" {
    run grep 'watch_file nix/bats-with-libs-for.nix' .envrc
    assert_success
}
