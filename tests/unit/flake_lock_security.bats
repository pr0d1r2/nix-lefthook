#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
}

@test "set-and-setting follows the repository nixpkgs lock" {
    run nix eval --raw --impure --expr '
      let
        lock = builtins.fromJSON (builtins.readFile ./flake.lock);
        root = lock.nodes.${lock.root};
        setAndSetting = lock.nodes.${root.inputs.set-and-setting};
      in
        if builtins.elem root.inputs.nixpkgs-lock setAndSetting.inputs.nixpkgs-lock
        then "yes"
        else "no"
    '
    assert_success
    assert_output "yes"
}

@test "the locked nixpkgs provides a fixed brotli" {
    run nix eval --raw --impure --expr '
      (builtins.getFlake (toString ./.)).inputs.nixpkgs.legacyPackages.aarch64-darwin.brotli.version
    '
    assert_success
    assert_output "1.2.1"
}
