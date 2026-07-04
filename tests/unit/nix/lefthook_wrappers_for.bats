#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "nix/lefthook-wrappers-for.nix exists" {
    assert [ -f nix/lefthook-wrappers-for.nix ]
}

@test "nix/lefthook-wrappers-for.nix takes parameter set with batsWithLibsFor" {
    run grep 'batsWithLibsFor' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix takes pkgs parameter" {
    run grep '^pkgs:$' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix uses writeShellApplication" {
    run grep 'writeShellApplication' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix defines wrap helper" {
    run grep 'wrap =' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix wraps lefthook-shellcheck" {
    run grep 'lefthook-shellcheck' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix wraps lefthook-statix" {
    run grep 'lefthook-statix' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix wraps lefthook-deadnix" {
    run grep 'lefthook-deadnix' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix wraps lefthook-nixfmt" {
    run grep 'lefthook-nixfmt' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix wraps lefthook-yamllint" {
    run grep 'lefthook-yamllint' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "nix/lefthook-wrappers-for.nix does not import other nix modules" {
    run grep -c 'import ./\|import ../\|import /' nix/lefthook-wrappers-for.nix
    assert_failure
}

@test "nix/lefthook-wrappers-for.nix returns a list" {
    run grep '^\[' nix/lefthook-wrappers-for.nix
    assert_success
}

@test "flake.nix imports nix/lefthook-wrappers-for.nix" {
    run grep 'import ./nix/lefthook-wrappers-for.nix' flake.nix
    assert_success
}

@test ".envrc watches nix/lefthook-wrappers-for.nix" {
    run grep 'watch_file nix/lefthook-wrappers-for.nix' .envrc
    assert_success
}
