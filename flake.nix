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

      pkgsWithOverlay =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ lefthookOverlay ];
        };
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
          overlaidPkgs = pkgsWithOverlay system;
          shells = nix-dev-shell-agentic.lib.mkShells {
            pkgs = overlaidPkgs;
            inherit inputs;
            shellHook = builtins.replaceStrings [ "@BATS_LIB_PATH@" ] [ "${shells.batsWithLibs}" ] (
              builtins.readFile ./dev.sh
            );
          };
        in
        shells
      );
    };
}
