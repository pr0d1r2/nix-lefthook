#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "CHANGELOG.md exists" {
    assert [ -f CHANGELOG.md ]
}

@test "CHANGELOG.md starts with Changelog heading" {
    run head -1 CHANGELOG.md
    assert_output "# Changelog"
}

@test "CHANGELOG.md has Unreleased section" {
    run grep -q '## \[Unreleased\]' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md contains current version 2.1.8" {
    run grep -q '## \[2\.1\.8\]' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists wrapper scripts under Added" {
    run grep -q 'lefthook-shellcheck' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists statix wrapper" {
    run grep -q 'lefthook-statix' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists deadnix wrapper" {
    run grep -q 'lefthook-deadnix' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists nixfmt wrapper" {
    run grep -q 'lefthook-nixfmt' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists yamllint wrapper" {
    run grep -q 'lefthook-yamllint' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists typos wrapper" {
    run grep -q 'lefthook-typos' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists gitleaks wrapper" {
    run grep -q 'lefthook-gitleaks' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md lists markdownlint-agentic wrapper" {
    run grep -q 'lefthook-markdownlint-agentic' CHANGELOG.md
    assert_success
}

@test "CHANGELOG.md has an Added subsection" {
    run grep -q '### Added' CHANGELOG.md
    assert_success
}
