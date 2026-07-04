#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "nix/lefthook-for.nix exists" {
    assert [ -f nix/lefthook-for.nix ]
}

@test "nix/lefthook-for.nix takes version parameter" {
    run grep '{ version }' nix/lefthook-for.nix
    assert_success
}

@test "nix/lefthook-for.nix takes pkgs parameter" {
    run grep '^pkgs:$' nix/lefthook-for.nix
    assert_success
}

@test "nix/lefthook-for.nix uses buildGo126Module" {
    run grep 'buildGo126Module' nix/lefthook-for.nix
    assert_success
}

@test "nix/lefthook-for.nix sets pname to lefthook" {
    run grep 'pname = "lefthook"' nix/lefthook-for.nix
    assert_success
}

@test "nix/lefthook-for.nix inherits version" {
    run grep 'inherit version' nix/lefthook-for.nix
    assert_success
}

@test "nix/lefthook-for.nix fetches from evilmartians" {
    run grep 'owner = "evilmartians"' nix/lefthook-for.nix
    assert_success
}

@test "nix/lefthook-for.nix sets mainProgram to lefthook" {
    run grep 'mainProgram = "lefthook"' nix/lefthook-for.nix
    assert_success
}

@test "nix/lefthook-for.nix does not contain shell logic" {
    run grep -c 'writeShellApplication\|writeShellScriptBin\|shellHook' nix/lefthook-for.nix
    assert_failure
}

@test "flake.nix imports nix/lefthook-for.nix" {
    run grep 'import ./nix/lefthook-for.nix' flake.nix
    assert_success
}

@test ".envrc watches nix/lefthook-for.nix" {
    run grep 'watch_file nix/lefthook-for.nix' .envrc
    assert_success
}
