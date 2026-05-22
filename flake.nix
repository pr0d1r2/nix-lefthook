{
  description = "Pinned lefthook binary — single source of truth for all repos";

  nixConfig = {
    extra-substituters = [ "https://pr0d1r2.cachix.org" ];
    extra-trusted-public-keys = [ "pr0d1r2.cachix.org-1:NfWjbhgAj41byXhCKiaE+av3Vnphm1fTezHXEGsiQIM=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-dev-shell-agentic = {
      url = "github:pr0d1r2/nix-dev-shell-agentic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-dev-shell-agentic,
      ...
    }@inputs:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});

      version = "2.1.6";
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.buildGo126Module {
          pname = "lefthook";
          inherit version;

          src = pkgs.fetchFromGitHub {
            owner = "evilmartians";
            repo = "lefthook";
            rev = "v${version}";
            hash = "sha256-thMjOtAAWrKvQDUlJmnvT1QT2CDx42XKlzV+weFsFrA=";
          };

          vendorHash = "sha256-75jrXoBXoPCE/Ue7OlGAA4nUDXHM5ccIaK4rsKgfG84=";

          ldflags = [
            "-s"
            "-w"
            "-X github.com/evilmartians/lefthook/internal/version.Version=${version}"
          ];

          doCheck = false;

          meta = {
            description = "Fast and powerful Git hooks manager for any type of projects";
            homepage = "https://github.com/evilmartians/lefthook";
            license = pkgs.lib.licenses.mit;
            mainProgram = "lefthook";
          };
        };
      });

      devShells = forAllSystems (
        pkgs:
        let
          inherit (pkgs.stdenv.hostPlatform) system;
          shells = nix-dev-shell-agentic.lib.mkShells {
            inherit pkgs inputs;
            ciPackages = [
              self.packages.${system}.default
            ];
            shellHook = builtins.replaceStrings [ "@BATS_LIB_PATH@" ] [ "${shells.batsWithLibs}" ] (
              builtins.readFile ./dev.sh
            );
          };
        in
        shells
      );
    };
}
