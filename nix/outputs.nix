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
  wrapperChecksFor = pkgs: import ./checks-for.nix { inherit lefthookWrappersFor; } pkgs;
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
    "actions"
    "nix"
    "shell"
    "ascii"
    "markdown"
    "yaml"
    "bats"
    "toml"
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
      lefthookFiles = pkgs.runCommand "lefthook-materialized-files" { } ''
        cp -R --no-preserve=mode ${mat.files} $out
        sed -i '/LEFTHOOK_TDD_SPEC_DIR=/d' $out/lefthook.yml
      '';
      sys = pkgs.stdenv.hostPlatform.system;
      # The materialized wrappers come first, so hooks run set-and-setting's
      # versions; this flake's own wrappers follow, so its tests can run
      # every wrapper it builds.
      localWrappers = map (wrapper: self.packages.${sys}.${wrapper.name}) (lefthookWrappersFor pkgs);
      basePackages =
        assert builtins.hasAttr "lefthook-bats-unit" self.packages.${sys};
        mat.packages
        ++ [
          (lefthookFor pkgs)
          pkgs.actionlint
          pkgs.nix
        ]
        ++ localWrappers;
      defaultShellHook = ''
        ${self.packages.${sys}.setting}/bin/sync-setting .
        cp -f ${lefthookFiles}/lefthook.yml lefthook.yml
      '';
    in
    (sas.lib.mkDevShells {
      inherit pkgs basePackages defaultShellHook;
    })
    // {
      ci = pkgs.mkShell {
        packages = basePackages;
        shellHook = builtins.readFile ../scripts/ci-shell-hook.sh + defaultShellHook;
      };
    }
  );

  checks = forAllSystems (
    pkgs:
    (sas.lib.checksFor {
      inherit pkgs;
      fragments = builtins.filter (fragment: fragment != "actions") fragments;
      src = ./..;
    })
    # Every wrapper this flake builds is executable and parses (bash -n).
    // wrapperChecksFor pkgs
    // {
      # set-and-setting's actionlint check currently passes a scalar regex to
      # nixpkgs' sourceByRegex, whose API requires a list of regexes. Keep the
      # actions check enabled locally while supplying the correct API shape.
      actionlint =
        let
          source = pkgs.lib.sources.sourceByRegex ./.. [ "^.github/workflows/.*" ];
          wrapper = builtins.head (
            builtins.filter (w: w.name == "lefthook-actionlint") (lefthookWrappersFor pkgs)
          );
        in
        pkgs.runCommand "actionlint-check" { } ''
          cd ${source}
          ${pkgs.lib.getExe wrapper} --check .github/workflows/*.yml .github/workflows/*.yaml
          touch $out
        '';
    }
    // {
      # The devShell copies the generated lefthook.yml over the tracked one
      # on every entry. Fail when they differ, so the committed file is
      # always the one hooks and CI actually run.
      lefthook-yml-generated =
        let
          mat = sas.lib.materializationFor { inherit pkgs fragments; };
          lefthookFiles = pkgs.runCommand "lefthook-materialized-files" { } ''
            cp -R --no-preserve=mode ${mat.files} $out
            sed -i '/LEFTHOOK_TDD_SPEC_DIR=/d' $out/lefthook.yml
          '';
        in
        pkgs.runCommand "lefthook-yml-generated-check" {
          nativeBuildInputs = [ pkgs.diffutils ];
        } "diff -u ${../lefthook.yml} ${lefthookFiles}/lefthook.yml && touch $out";
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
