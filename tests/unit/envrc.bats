#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test ".envrc watches flake.nix for changes" {
    run grep -q '^watch_file flake\.nix$' .envrc
    assert_success
}

@test ".envrc watches flake.lock for changes" {
    run grep -q '^watch_file flake\.lock$' .envrc
    assert_success
}

@test ".envrc watches dev.sh for changes" {
    run grep -q '^watch_file dev\.sh$' .envrc
    assert_success
}

@test ".envrc watches nix/lefthook-for.nix for changes" {
    run grep -q '^watch_file nix/lefthook-for\.nix$' .envrc
    assert_success
}

@test ".envrc watches nix/bats-with-libs-for.nix for changes" {
    run grep -q '^watch_file nix/bats-with-libs-for\.nix$' .envrc
    assert_success
}

@test ".envrc watches nix/lefthook-wrappers-for.nix for changes" {
    run grep -q '^watch_file nix/lefthook-wrappers-for\.nix$' .envrc
    assert_success
}

@test ".envrc watches nix/checks-for.nix for changes" {
    run grep -q '^watch_file nix/checks-for\.nix$' .envrc
    assert_success
}

@test ".envrc watches nix/checks-wrappers.sh for changes" {
    run grep -q '^watch_file nix/checks-wrappers\.sh$' .envrc
    assert_success
}

@test ".envrc uses flake" {
    run grep -q '^use flake$' .envrc
    assert_success
}

@test ".envrc has use flake as last line" {
    run tail -1 .envrc
    assert_output "use flake"
}
