#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook binary is on PATH" {
    run command -v lefthook
    assert_success
}

@test "lefthook reports correct version" {
    run lefthook version
    assert_success
    assert_output --partial "2.1.6"
}

@test "lefthook --help exits successfully" {
    run lefthook --help
    assert_success
}
