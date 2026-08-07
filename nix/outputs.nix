{
  self,
  nixpkgs,
  set-and-setting,
  nix-lefthook-actionlint-src,
  nix-lefthook-bats-failures-only-src,
  nix-lefthook-bats-parse-src,
  nix-lefthook-bats-unit-src,
  nix-lefthook-changelog-touched-src,
  nix-lefthook-commit-msg-lint-src,
  nix-lefthook-deadnix-src,
  nix-lefthook-editorconfig-checker-src,
  nix-lefthook-file-size-check-src,
  nix-lefthook-git-conflict-markers-src,
  nix-lefthook-git-no-local-paths-src,
  nix-lefthook-gitleaks-src,
  nix-lefthook-justfile-alphabetical-src,
  nix-lefthook-justfile-no-embedded-shell-src,
  nix-lefthook-linter-coverage-full-src,
  nix-lefthook-markdownlint-agentic-src,
  nix-lefthook-markdownlint-src,
  nix-lefthook-missing-final-newline-src,
  nix-lefthook-narrow-language-src,
  nix-lefthook-nix-flake-check-src,
  nix-lefthook-nix-flake-eval-src,
  nix-lefthook-nix-no-embedded-shell-src,
  nix-lefthook-nixfmt-src,
  nix-lefthook-no-shell-functions-src,
  nix-lefthook-pre-rebase-merged-commits-src,
  nix-lefthook-shellcheck-src,
  nix-lefthook-shfmt-src,
  nix-lefthook-statix-src,
  nix-lefthook-taplo-src,
  nix-lefthook-tdd-order-bats-src,
  nix-lefthook-trailing-whitespace-src,
  nix-lefthook-typos-src,
  nix-lefthook-unicode-lint-src,
  nix-lefthook-unit-coverage-src,
  nix-lefthook-yamllint-src,
  ...
}:
let
  sas = set-and-setting;
  supportedSystems = [
    "aarch64-darwin"
    "x86_64-darwin"
    "x86_64-linux"
    "aarch64-linux"
  ];
  forAllSystems =
    f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});

  version = "2.1.8";
  lefthookFor = import ./lefthook-for.nix { inherit version; };
  lefthookOverlay = _final: _prev: { lefthook = lefthookFor _prev; };
  batsWithLibsFor = import ./bats-with-libs-for.nix;
  lefthookWrappersFor = import ./lefthook-wrappers-for.nix {
    inherit
      batsWithLibsFor
      nix-lefthook-actionlint-src
      nix-lefthook-bats-failures-only-src
      nix-lefthook-bats-parse-src
      nix-lefthook-bats-unit-src
      nix-lefthook-changelog-touched-src
      nix-lefthook-commit-msg-lint-src
      nix-lefthook-deadnix-src
      nix-lefthook-editorconfig-checker-src
      nix-lefthook-file-size-check-src
      nix-lefthook-git-conflict-markers-src
      nix-lefthook-git-no-local-paths-src
      nix-lefthook-gitleaks-src
      nix-lefthook-justfile-alphabetical-src
      nix-lefthook-justfile-no-embedded-shell-src
      nix-lefthook-linter-coverage-full-src
      nix-lefthook-markdownlint-agentic-src
      nix-lefthook-markdownlint-src
      nix-lefthook-missing-final-newline-src
      nix-lefthook-narrow-language-src
      nix-lefthook-nix-flake-check-src
      nix-lefthook-nix-flake-eval-src
      nix-lefthook-nix-no-embedded-shell-src
      nix-lefthook-nixfmt-src
      nix-lefthook-no-shell-functions-src
      nix-lefthook-pre-rebase-merged-commits-src
      nix-lefthook-shellcheck-src
      nix-lefthook-shfmt-src
      nix-lefthook-statix-src
      nix-lefthook-taplo-src
      nix-lefthook-tdd-order-bats-src
      nix-lefthook-trailing-whitespace-src
      nix-lefthook-typos-src
      nix-lefthook-unicode-lint-src
      nix-lefthook-unit-coverage-src
      nix-lefthook-yamllint-src
      ;
  };

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
  packages = forAllSystems (
    pkgs:
    {
      setting = (sas.lib.mkSetting { inherit pkgs; }).materialized;
      default = lefthookFor pkgs;
    }
    // builtins.listToAttrs (
      map (w: {
        inherit (w) name;
        value = w;
      }) (lefthookWrappersFor pkgs)
    )
  );

  overlays.default = lefthookOverlay;

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
      src = ./..;
    })
    // {
      dep-graph = sas.lib.mkDepGraphCheck {
        inherit pkgs;
        projectRoot = ./..;
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
                (builtins.readFile ../scripts/confirm.sh);
          }
        }/bin/confirm";
      };
    }
  );
}
