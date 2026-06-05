#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "lefthook.yml configures output to show only failures" {
    run bash -c "grep -A1 '^output:' lefthook.yml | grep -q 'failure'"
    assert_success
}

@test "lefthook.yml output has only failure entry" {
    run bash -c "sed -n '/^output:/,/^[^ ]/{ /^  - /p }' lefthook.yml"
    assert_success
    assert_output "  - failure"
}
