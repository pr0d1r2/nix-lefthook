#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"

    if command -v nix >/dev/null 2>&1; then
        LEFTHOOK="$(nix build --no-link --print-out-paths 2>/dev/null)/bin/lefthook"
    else
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
