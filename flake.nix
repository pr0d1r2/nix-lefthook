{
  description = "Pinned lefthook binary — single source of truth for all repos";

  nixConfig = {
    extra-substituters = [ "https://pr0d1r2.cachix.org" ];
    extra-trusted-public-keys = [ "pr0d1r2.cachix.org-1:NfWjbhgAj41byXhCKiaE+av3Vnphm1fTezHXEGsiQIM=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-lefthook-taplo = {
      url = "github:pr0d1r2/nix-lefthook-taplo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-markdownlint-agentic = {
      url = "github:pr0d1r2/nix-lefthook-markdownlint-agentic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-lefthook-taplo,
      nix-lefthook-markdownlint-agentic,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      version = "2.1.8";

      lefthookFor =
        pkgs:
        pkgs.buildGo126Module {
          pname = "lefthook";
          inherit version;

          src = pkgs.fetchFromGitHub {
            owner = "evilmartians";
            repo = "lefthook";
            rev = "v${version}";
            hash = "sha256-ZCdDRJw59M/Uy0/z2fsNc/KRQx0ZXANOe1UFJZE7ffQ=";
          };

          vendorHash = "sha256-jVjdGnNRRFTjd2/DjKHZmLWkbtb3eEQ+R/yw1LBa3bE=";

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

      lefthookOverlay = _final: _prev: {
        lefthook = lefthookFor _prev;
      };

      forAllSystems =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});

      batsWithLibsFor =
        pkgs:
        pkgs.bats.withLibraries (p: [
          p.bats-support
          p.bats-assert
          p.bats-file
        ]);
    in
    {
      packages = forAllSystems (pkgs: {
        default = lefthookFor pkgs;
      });

      overlays.default = lefthookOverlay;

      devShells = forAllSystems (
        pkgs:
        let
          inherit (pkgs.stdenv.hostPlatform) system;
          batsWithLibs = batsWithLibsFor pkgs;
          ciPackages = [
            (lefthookFor pkgs)
            pkgs.coreutils
            pkgs.deadnix
            pkgs.editorconfig-checker
            pkgs.git
            pkgs.gitleaks
            pkgs.nix
            pkgs.nixfmt
            pkgs.parallel
            pkgs.shellcheck
            pkgs.shfmt
            pkgs.statix
            pkgs.typos
            pkgs.yamllint
            pkgs.markdownlint-cli
            nix-lefthook-taplo.packages.${system}.default
            nix-lefthook-markdownlint-agentic.packages.${system}.default
            batsWithLibs
          ];
        in
        {
          ci = pkgs.mkShell {
            packages = ciPackages;
            BATS_LIB_PATH = "${batsWithLibs}/share/bats";
          };
          default = pkgs.mkShell {
            packages = ciPackages ++ [
              pkgs.gh
              pkgs.nodejs
            ];
            BATS_LIB_PATH = "${batsWithLibs}/share/bats";
            shellHook = builtins.replaceStrings [ "@BATS_LIB_PATH@" ] [ "${batsWithLibs}" ] (
              builtins.readFile ./dev.sh
            );
          };
        }
      );
    };
}
