#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "README documents the six migrated wrapper package names" {
    for wrapper in \
        lefthook-bats-parse \
        lefthook-editorconfig-checker \
        lefthook-git-no-local-paths \
        lefthook-justfile-alphabetical \
        lefthook-markdownlint \
        lefthook-yamllint; do
        run grep -F "nix-lefthook.packages.\${pkgs.stdenv.hostPlatform.system}.$wrapper" README.md
        assert_success
    done
}

@test "README warns against the removed per-hook default packages" {
    run grep -F 'Do not use `inputs.nix-lefthook-<name>.packages.${system}.default`' README.md
    assert_success
}

@test "README documents removal of the obsolete bats failures-only follow" {
    run grep -F 'remove obsolete `inputs.nix-lefthook-bats-failures-only` follows' README.md
    assert_success
}
