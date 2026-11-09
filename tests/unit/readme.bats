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
    run grep -F "[![NixOS $channel](https://img.shields.io/badge/NixOS-$channel-blue.svg?logo=nixos)](https://nixos.org)" README.md
    assert_success
}

@test "README has an Architecture section with a mermaid diagram" {
    run awk '/^## Architecture$/{s=1; next} /^## /{s=0} s && /^```mermaid$/{f=1} END{exit !f}' README.md
    assert_success
}

@test "README has a Development architecture section with a mermaid diagram" {
    run awk '/^## Development architecture$/{s=1; next} /^## /{s=0} s && /^```mermaid$/{f=1} END{exit !f}' README.md
    assert_success
}
