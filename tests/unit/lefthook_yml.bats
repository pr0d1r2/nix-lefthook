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

@test "lefthook.yml pre-commit has local commands" {
    run bash -c "awk '/^pre-commit:/,/^pre-push:/' lefthook.yml | grep -q '^  commands:'"
    assert_success
}

@test "lefthook.yml pre-push has local commands" {
    run bash -c "awk '/^pre-push:/,0' lefthook.yml | grep -q '^  commands:'"
    assert_success
}

@test "lefthook.yml pre-commit and pre-push have same commands" {
    run bash -c "
        pre_commit=\$(awk '/^pre-commit:/,/^pre-push:/' lefthook.yml | grep '^    [a-z]' | sed 's/:.*//' | sed 's/^ *//' | sort)
        pre_push=\$(awk '/^pre-push:/,0' lefthook.yml | grep '^    [a-z]' | sed 's/:.*//' | sed 's/^ *//' | sort)
        diff <(echo \"\$pre_commit\") <(echo \"\$pre_push\")
    "
    assert_success
}

@test "lefthook.yml every command run includes timeout" {
    run bash -c "grep '^      run:' lefthook.yml | grep -v 'timeout' | wc -l | tr -d ' '"
    assert_output "0"
}

@test "lefthook.yml pre-commit commands use staged_files" {
    run bash -c "awk '/^pre-commit:/,/^pre-push:/' lefthook.yml | grep '^      run:' | grep -v '{staged_files}' | grep -v 'nix flake check' | wc -l | tr -d ' '"
    assert_output "0"
}

@test "lefthook.yml pre-push commands use push_files" {
    run bash -c "awk '/^pre-push:/,0' lefthook.yml | grep '^      run:' | grep -v '{push_files}' | grep -v 'nix flake check' | wc -l | tr -d ' '"
    assert_output "0"
}
