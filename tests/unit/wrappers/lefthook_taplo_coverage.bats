#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test ".gitleaks.toml is tracked in git" {
    run git ls-files --error-unmatch .gitleaks.toml
    assert_success
}

@test ".rtk/filters.toml is tracked in git" {
    run git ls-files --error-unmatch .rtk/filters.toml
    assert_success
}

@test "lefthook.yml pre-commit taplo command has toml glob" {
    run bash -c "awk '/^pre-commit:/,/^pre-push:/' lefthook.yml | grep -A1 '^    taplo:' | grep -q 'glob:.*\\.toml'"
    assert_success
}

@test "lefthook.yml pre-push taplo command has toml glob" {
    run bash -c "awk '/^pre-push:/,0' lefthook.yml | grep -A1 '^    taplo:' | grep -q 'glob:.*\\.toml'"
    assert_success
}

@test "lefthook.yml pre-commit taplo command uses lefthook-taplo" {
    run bash -c "awk '/^pre-commit:/,/^pre-push:/' lefthook.yml | grep -A2 '^    taplo:' | grep -q 'lefthook-taplo'"
    assert_success
}

@test "lefthook.yml pre-push taplo command uses lefthook-taplo" {
    run bash -c "awk '/^pre-push:/,0' lefthook.yml | grep -A2 '^    taplo:' | grep -q 'lefthook-taplo'"
    assert_success
}

@test "all tracked TOML files match the taplo glob pattern" {
    run bash -c "
        toml_files=\$(git ls-files '*.toml')
        if [ -z \"\$toml_files\" ]; then
            echo 'no TOML files tracked'
            exit 1
        fi
        for f in \$toml_files; do
            case \"\$f\" in
                *.toml) ;;
                *) echo \"file \$f does not match *.toml glob\"; exit 1 ;;
            esac
        done
    "
    assert_success
}

@test "tracked TOML files include .gitleaks.toml" {
    run bash -c "git ls-files '*.toml' | grep -q '^\\.gitleaks\\.toml$'"
    assert_success
}

@test "tracked TOML files include .rtk/filters.toml" {
    run bash -c "git ls-files '*.toml' | grep -q '^\\.rtk/filters\\.toml$'"
    assert_success
}
