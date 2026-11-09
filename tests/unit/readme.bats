#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "README NixOS badge matches the locked nixpkgs channel" {
    # The root follows nixpkgs-lock/nixpkgs; read that node's channel ref.
    ref="$(nix eval --raw --impure --expr '
      let
        lock = builtins.fromJSON (builtins.readFile ./flake.lock);
        nodes = lock.nodes;
        nixpkgsLock = nodes.${nodes.${lock.root}.inputs.nixpkgs-lock};
      in nodes.${nixpkgsLock.inputs.nixpkgs}.original.ref')"
    channel="${ref#nixos-}"
    [ "$channel" != "$ref" ]
    # The header badge line is the first line that starts with a badge.
    header="$(grep -m1 '^\[!\[' README.md)"
    expected="[![NixOS $channel](https://img.shields.io/badge/NixOS-$channel-blue.svg?logo=nixos)](https://nixos.org)"
    [[ "$header" == *"$expected"* ]]
}

# Succeeds when the section has a mermaid fence that closes before the
# next level-2 heading.
mermaid_closed_in_section='
  $0 == "## " title { s = 1; next }
  /^## / { if (s && open) exit 1; s = 0 }
  s && !open && /^```mermaid$/ { open = 1; next }
  s && open && /^```$/ { open = 0; closed = 1 }
  END { exit !(closed && !open) }
'

@test "README has an Architecture section with a closed mermaid diagram" {
    run awk -v title="Architecture" "$mermaid_closed_in_section" README.md
    assert_success
}

@test "README has a Development architecture section with a closed mermaid diagram" {
    run awk -v title="Development architecture" "$mermaid_closed_in_section" README.md
    assert_success
}

@test "an unclosed mermaid fence fails the section check" {
    printf '## Architecture\n\n```mermaid\nflowchart LR\n\n## Next\n' >"$BATS_TEST_TMPDIR/README.md"
    run awk -v title="Architecture" "$mermaid_closed_in_section" "$BATS_TEST_TMPDIR/README.md"
    assert_failure
}
