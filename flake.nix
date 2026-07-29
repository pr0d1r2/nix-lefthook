{
  description = "CHANGEME";

  nixConfig = {
    extra-substituters = [ "https://pr0d1r2.cachix.org" ];
    extra-trusted-public-keys = [ "pr0d1r2.cachix.org-1:NfWjbhgAj41byXhCKiaE+av3Vnphm1fTezHXEGsiQIM=" ];
  };

  inputs = {
    nixpkgs-lock.url = "github:pr0d1r2/nixpkgs-lock";
    nixpkgs.follows = "nixpkgs-lock/nixpkgs";

    set-and-setting.url = "github:pr0d1r2/set-and-setting";
  };

  outputs =
    {
      self,
      nixpkgs,
      set-and-setting,
      ...
    }:
    let
      sas = set-and-setting.inputs.set-and-setting;
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});

      fragments = [
        "base"
        "nix"
        "shell"
        "ascii"
        "markdown"
        "yaml"
      ];
    in
    {
      packages = forAllSystems (pkgs: {
        setting = (sas.lib.mkSetting { inherit pkgs; }).materialized;
      });

      devShells = forAllSystems (
        pkgs:
        let
          mat = sas.lib.materializationFor { inherit pkgs fragments; };
          sys = pkgs.stdenv.hostPlatform.system;
        in
        sas.lib.mkDevShells {
          inherit pkgs;
          basePackages = mat.packages;
          defaultShellHook = ''
            ${self.packages.${sys}.setting}/bin/sync-setting .
            cp -f ${mat.files}/lefthook.yml lefthook.yml
          '';
        }
      );

      checks = forAllSystems (
        pkgs:
        (sas.lib.checksFor {
          inherit pkgs fragments;
          src = ./.;
        })
        // {
          dep-graph = sas.lib.mkDepGraphCheck {
            inherit pkgs;
            projectRoot = ./.;
          };
          default = pkgs.runCommand "checks" { } "touch $out";
        }
      );

      apps = forAllSystems (
        pkgs:
        let
          mat = sas.lib.materializationFor { inherit pkgs fragments; };
        in
        {
          confirm = {
            type = "app";
            program = "${
              pkgs.writeShellApplication {
                name = "confirm";
                runtimeInputs = mat.packages ++ [
                  pkgs.coreutils
                  pkgs.diffutils
                  pkgs.findutils
                  pkgs.gawk
                  pkgs.git
                  pkgs.gnugrep
                ];
                text =
                  builtins.replaceStrings
                    [
                      "@FRAGMENTS_DIR@"
                      "@ASSEMBLE_SCRIPT@"
                      "@DETECT_SCRIPT@"
                      "@SETTING_SRC@"
                      "@CONFIRM_SCRIPT@"
                      "@CONFIRM_REV@"
                    ]
                    [
                      "${sas}/setting/integrations/lefthook"
                      "${sas}/setting/lib/assemble-lefthook.sh"
                      "${sas}/setting/lib/detect-fragments.sh"
                      "${self.packages.${pkgs.stdenv.hostPlatform.system}.setting}"
                      "${sas}/lib/confirm.sh"
                      (sas.rev or "unknown")
                    ]
                    (builtins.readFile ./scripts/confirm.sh);
              }
            }/bin/confirm";
          };
        }
      );
    };
}
