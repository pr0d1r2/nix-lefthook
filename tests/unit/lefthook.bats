#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"

    LEFTHOOK="$(nix build --no-link --print-out-paths 2>/dev/null)/bin/lefthook"
    if [ ! -x "$LEFTHOOK" ]; then
        LEFTHOOK="$(command -v lefthook)"
    fi
}

@test "nix build produces lefthook binary" {
    assert [ -x "$LEFTHOOK" ]
}

@test "built binary reports correct version" {
    run "$LEFTHOOK" version
    assert_success
    assert_output --partial "2.1.8"
}

@test "built binary --help exits successfully" {
    run "$LEFTHOOK" --help
    assert_success
}
