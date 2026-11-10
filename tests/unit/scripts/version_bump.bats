#!/usr/bin/env bats

setup() {
  load "${BATS_LIB_PATH}/bats-support/load.bash"
  load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "scripts/version-bump.sh exists" {
  assert [ -f scripts/version-bump.sh ]
}

@test "scripts/version-bump.sh is valid bash" {
  run bash -n scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh exits with error when no version is provided" {
  run bash scripts/version-bump.sh
  assert_failure
}

@test "scripts/version-bump.sh shows usage when no version is provided" {
  run bash -c 'bash scripts/version-bump.sh 2>&1'
  assert_failure
  assert_output --partial "Usage"
}

@test "scripts/version-bump.sh uses set -euo pipefail" {
  run grep 'set -euo pipefail' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh updates version in nix/outputs.nix" {
  run grep -E 'version.*nix/outputs\.nix' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh updates hash in nix/lefthook-for.nix" {
  run grep -E 'hash.*nix/lefthook-for\.nix' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh updates vendorHash in nix/lefthook-for.nix" {
  run grep -E 'vendorHash.*nix/lefthook-for\.nix' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh uses nix-prefetch-url for source hash" {
  run grep 'nix-prefetch-url' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh fetches from evilmartians/lefthook" {
  run grep 'evilmartians/lefthook' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh uses nix hash for SRI conversion" {
  run grep 'nix hash' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh uses nix build for vendorHash computation" {
  run grep 'nix build' scripts/version-bump.sh
  assert_success
}

@test "scripts/version-bump.sh does not contain shell functions" {
  run grep -c '^[a-zA-Z_]*()' scripts/version-bump.sh
  assert_failure
}

@test "scripts/version-bump.sh correctly updates version in mock nix/outputs.nix" {
  MOCK_DIR="$(mktemp -d)"
  mkdir -p "$MOCK_DIR/nix"
  printf '  version = "1.0.0";\n' >"$MOCK_DIR/nix/outputs.nix"
  cat >"$MOCK_DIR/nix/lefthook-for.nix" <<'NIX'
    hash = "sha256-OldSourceHash000000000000000000000000000000=";
    vendorHash = "sha256-OldVendorHash000000000000000000000000000000=";
NIX
  mkdir -p "$MOCK_DIR/bin"
  printf '#!/usr/bin/env bash\necho "0sri0000000000000000000000000000000000000000000000"\n' >"$MOCK_DIR/bin/nix-prefetch-url"
  chmod +x "$MOCK_DIR/bin/nix-prefetch-url"
  cat >"$MOCK_DIR/bin/nix" <<'SH'
#!/usr/bin/env bash
if [ "$1" = "hash" ]; then
    echo "sha256-NewSourceHash000000000000000000000000000000="
elif [ "$1" = "build" ]; then
    echo "         got:    sha256-NewVendorHash000000000000000000000000000000=" >&2
    exit 1
fi
SH
  chmod +x "$MOCK_DIR/bin/nix"
  cp scripts/version-bump.sh "$MOCK_DIR/"
  pushd "$MOCK_DIR" >/dev/null
  PATH="$MOCK_DIR/bin:$PATH" bash version-bump.sh 2.0.0
  popd >/dev/null
  run grep 'version = "2.0.0"' "$MOCK_DIR/nix/outputs.nix"
  assert_success
  rm -rf "$MOCK_DIR"
}

@test "scripts/version-bump.sh correctly updates hash in mock lefthook-for.nix" {
  MOCK_DIR="$(mktemp -d)"
  mkdir -p "$MOCK_DIR/nix"
  printf '  version = "1.0.0";\n' >"$MOCK_DIR/nix/outputs.nix"
  cat >"$MOCK_DIR/nix/lefthook-for.nix" <<'NIX'
    hash = "sha256-OldSourceHash000000000000000000000000000000=";
    vendorHash = "sha256-OldVendorHash000000000000000000000000000000=";
NIX
  mkdir -p "$MOCK_DIR/bin"
  printf '#!/usr/bin/env bash\necho "0sri0000000000000000000000000000000000000000000000"\n' >"$MOCK_DIR/bin/nix-prefetch-url"
  chmod +x "$MOCK_DIR/bin/nix-prefetch-url"
  cat >"$MOCK_DIR/bin/nix" <<'SH'
#!/usr/bin/env bash
if [ "$1" = "hash" ]; then
    echo "sha256-NewSourceHash000000000000000000000000000000="
elif [ "$1" = "build" ]; then
    echo "         got:    sha256-NewVendorHash000000000000000000000000000000=" >&2
    exit 1
fi
SH
  chmod +x "$MOCK_DIR/bin/nix"
  cp scripts/version-bump.sh "$MOCK_DIR/"
  pushd "$MOCK_DIR" >/dev/null
  PATH="$MOCK_DIR/bin:$PATH" bash version-bump.sh 2.0.0
  popd >/dev/null
  run grep 'sha256-NewSourceHash' "$MOCK_DIR/nix/lefthook-for.nix"
  assert_success
  rm -rf "$MOCK_DIR"
}

@test "scripts/version-bump.sh correctly updates vendorHash in mock lefthook-for.nix" {
  MOCK_DIR="$(mktemp -d)"
  mkdir -p "$MOCK_DIR/nix"
  printf '  version = "1.0.0";\n' >"$MOCK_DIR/nix/outputs.nix"
  cat >"$MOCK_DIR/nix/lefthook-for.nix" <<'NIX'
    hash = "sha256-OldSourceHash000000000000000000000000000000=";
    vendorHash = "sha256-OldVendorHash000000000000000000000000000000=";
NIX
  mkdir -p "$MOCK_DIR/bin"
  printf '#!/usr/bin/env bash\necho "0sri0000000000000000000000000000000000000000000000"\n' >"$MOCK_DIR/bin/nix-prefetch-url"
  chmod +x "$MOCK_DIR/bin/nix-prefetch-url"
  cat >"$MOCK_DIR/bin/nix" <<'SH'
#!/usr/bin/env bash
if [ "$1" = "hash" ]; then
    echo "sha256-NewSourceHash000000000000000000000000000000="
elif [ "$1" = "build" ]; then
    echo "         got:    sha256-NewVendorHash000000000000000000000000000000=" >&2
    exit 1
fi
SH
  chmod +x "$MOCK_DIR/bin/nix"
  cp scripts/version-bump.sh "$MOCK_DIR/"
  pushd "$MOCK_DIR" >/dev/null
  PATH="$MOCK_DIR/bin:$PATH" bash version-bump.sh 2.0.0
  popd >/dev/null
  run grep 'sha256-NewVendorHash' "$MOCK_DIR/nix/lefthook-for.nix"
  assert_success
  rm -rf "$MOCK_DIR"
}

@test "scripts/version-bump.sh fails when nix/outputs.nix has no version line" {
  MOCK_DIR="$(mktemp -d)"
  mkdir -p "$MOCK_DIR/nix" "$MOCK_DIR/bin"
  printf '{ }\n' >"$MOCK_DIR/nix/outputs.nix"
  printf '    hash = "sha256-OldSourceHash000000000000000000000000000000=";\n' >"$MOCK_DIR/nix/lefthook-for.nix"
  printf '#!/usr/bin/env bash\nexit 99\n' >"$MOCK_DIR/bin/nix-prefetch-url"
  chmod +x "$MOCK_DIR/bin/nix-prefetch-url"
  cp scripts/version-bump.sh "$MOCK_DIR/"
  pushd "$MOCK_DIR" >/dev/null
  PATH="$MOCK_DIR/bin:$PATH" run bash version-bump.sh 2.0.0
  popd >/dev/null
  assert_failure
  assert_output --partial "no version line in nix/outputs.nix"
  run grep 'OldSourceHash' "$MOCK_DIR/nix/lefthook-for.nix"
  assert_success
  rm -rf "$MOCK_DIR"
}
