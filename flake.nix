{
  description = "Pinned lefthook binary — single source of truth for all repos";

  nixConfig = {
    extra-substituters = [ "https://pr0d1r2.cachix.org" ];
    extra-trusted-public-keys = [ "pr0d1r2.cachix.org-1:NfWjbhgAj41byXhCKiaE+av3Vnphm1fTezHXEGsiQIM=" ];
  };

  inputs = {
    nixpkgs-lock.url = "github:pr0d1r2/nixpkgs-lock";
    nixpkgs.follows = "nixpkgs-lock/nixpkgs";
    nix-lefthook-taplo-src = {
      url = "github:pr0d1r2/nix-lefthook-taplo";
      flake = false;
    };
    nix-lefthook-markdownlint-agentic-src = {
      url = "github:pr0d1r2/nix-lefthook-markdownlint-agentic";
      flake = false;
    };
    nix-lefthook-git-conflict-markers-src = {
      url = "github:pr0d1r2/nix-lefthook-git-conflict-markers";
      flake = false;
    };
    nix-lefthook-git-no-local-paths-src = {
      url = "github:pr0d1r2/nix-lefthook-git-no-local-paths";
      flake = false;
    };
    nix-lefthook-missing-final-newline-src = {
      url = "github:pr0d1r2/nix-lefthook-missing-final-newline";
      flake = false;
    };
    nix-lefthook-nix-no-embedded-shell-src = {
      url = "github:pr0d1r2/nix-lefthook-nix-no-embedded-shell";
      flake = false;
    };
    nix-lefthook-statix-src = {
      url = "github:pr0d1r2/nix-lefthook-statix";
      flake = false;
    };
    nix-lefthook-trailing-whitespace-src = {
      url = "github:pr0d1r2/nix-lefthook-trailing-whitespace";
      flake = false;
    };
    nix-lefthook-deadnix-src = {
      url = "github:pr0d1r2/nix-lefthook-deadnix";
      flake = false;
    };
    nix-lefthook-editorconfig-checker-src = {
      url = "github:pr0d1r2/nix-lefthook-editorconfig-checker";
      flake = false;
    };
    nix-lefthook-nixfmt-src = {
      url = "github:pr0d1r2/nix-lefthook-nixfmt";
      flake = false;
    };
    nix-lefthook-shellcheck-src = {
      url = "github:pr0d1r2/nix-lefthook-shellcheck";
      flake = false;
    };
    nix-lefthook-shfmt-src = {
      url = "github:pr0d1r2/nix-lefthook-shfmt";
      flake = false;
    };
    nix-lefthook-typos-src = {
      url = "github:pr0d1r2/nix-lefthook-typos";
      flake = false;
    };
    nix-lefthook-yamllint-src = {
      url = "github:pr0d1r2/nix-lefthook-yamllint";
      flake = false;
    };
    nix-lefthook-bats-unit-src = {
      url = "github:pr0d1r2/nix-lefthook-bats-unit";
      flake = false;
    };
    nix-lefthook-gitleaks-src = {
      url = "github:pr0d1r2/nix-lefthook-gitleaks";
      flake = false;
    };
    nix-lefthook-actionlint-src = {
      url = "github:pr0d1r2/nix-lefthook-actionlint";
      flake = false;
    };
    nix-lefthook-bats-failures-only-src = {
      url = "github:pr0d1r2/nix-lefthook-bats-failures-only";
      flake = false;
    };
    nix-lefthook-bats-parse-src = {
      url = "github:pr0d1r2/nix-lefthook-bats-parse";
      flake = false;
    };
    nix-lefthook-changelog-touched-src = {
      url = "github:pr0d1r2/nix-lefthook-changelog-touched";
      flake = false;
    };
    nix-lefthook-commit-msg-lint-src = {
      url = "github:pr0d1r2/nix-lefthook-commit-msg-lint";
      flake = false;
    };
    nix-lefthook-file-size-check-src = {
      url = "github:pr0d1r2/nix-lefthook-file-size-check";
      flake = false;
    };
    nix-lefthook-justfile-alphabetical-src = {
      url = "github:pr0d1r2/nix-lefthook-justfile-alphabetical";
      flake = false;
    };
    nix-lefthook-justfile-no-embedded-shell-src = {
      url = "github:pr0d1r2/nix-lefthook-justfile-no-embedded-shell";
      flake = false;
    };
    nix-lefthook-linter-coverage-full-src = {
      url = "github:pr0d1r2/nix-lefthook-linter-coverage-full";
      flake = false;
    };
    nix-lefthook-narrow-language-src = {
      url = "github:pr0d1r2/nix-lefthook-narrow-language";
      flake = false;
    };
    nix-lefthook-nix-flake-check-src = {
      url = "github:pr0d1r2/nix-lefthook-nix-flake-check";
      flake = false;
    };
    nix-lefthook-nix-flake-eval-src = {
      url = "github:pr0d1r2/nix-lefthook-nix-flake-eval";
      flake = false;
    };
    nix-lefthook-no-shell-functions-src = {
      url = "github:pr0d1r2/nix-lefthook-no-shell-functions";
      flake = false;
    };
    nix-lefthook-pre-rebase-merged-commits-src = {
      url = "github:pr0d1r2/nix-lefthook-pre-rebase-merged-commits";
      flake = false;
    };
    nix-lefthook-tdd-order-bats-src = {
      url = "github:pr0d1r2/nix-lefthook-tdd-order-bats";
      flake = false;
    };
    nix-lefthook-unicode-lint-src = {
      url = "github:pr0d1r2/nix-lefthook-unicode-lint";
      flake = false;
    };
    nix-lefthook-unit-coverage-src = {
      url = "github:pr0d1r2/nix-lefthook-unit-coverage";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nix-lefthook-taplo-src,
      nix-lefthook-markdownlint-agentic-src,
      nix-lefthook-git-conflict-markers-src,
      nix-lefthook-git-no-local-paths-src,
      nix-lefthook-missing-final-newline-src,
      nix-lefthook-nix-no-embedded-shell-src,
      nix-lefthook-statix-src,
      nix-lefthook-trailing-whitespace-src,
      nix-lefthook-deadnix-src,
      nix-lefthook-editorconfig-checker-src,
      nix-lefthook-nixfmt-src,
      nix-lefthook-shellcheck-src,
      nix-lefthook-shfmt-src,
      nix-lefthook-typos-src,
      nix-lefthook-yamllint-src,
      nix-lefthook-bats-unit-src,
      nix-lefthook-gitleaks-src,
      nix-lefthook-actionlint-src,
      nix-lefthook-bats-failures-only-src,
      nix-lefthook-bats-parse-src,
      nix-lefthook-changelog-touched-src,
      nix-lefthook-commit-msg-lint-src,
      nix-lefthook-file-size-check-src,
      nix-lefthook-justfile-alphabetical-src,
      nix-lefthook-justfile-no-embedded-shell-src,
      nix-lefthook-linter-coverage-full-src,
      nix-lefthook-narrow-language-src,
      nix-lefthook-nix-flake-check-src,
      nix-lefthook-nix-flake-eval-src,
      nix-lefthook-no-shell-functions-src,
      nix-lefthook-pre-rebase-merged-commits-src,
      nix-lefthook-tdd-order-bats-src,
      nix-lefthook-unicode-lint-src,
      nix-lefthook-unit-coverage-src,
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

      lefthookFor = import ./nix/lefthook-for.nix { inherit version; };

      lefthookOverlay = _final: _prev: {
        lefthook = lefthookFor _prev;
      };

      forAllSystems =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});

      batsWithLibsFor = import ./nix/bats-with-libs-for.nix;

      lefthookWrappersFor =
        pkgs:
        let
          wrap =
            name: src: extra:
            pkgs.writeShellApplication (
              {
                inherit name;
                text = builtins.readFile "${src}/${name}.sh";
              }
              // extra
            );
          getFileSizeLimit = pkgs.writeShellApplication {
            name = "get-file-size-limit";
            runtimeInputs = [
              pkgs.gawk
              pkgs.gnugrep
            ];
            text = builtins.readFile "${nix-lefthook-file-size-check-src}/get-file-size-limit.sh";
          };
          linterCoverageAwk = pkgs.writeText "linter-coverage.awk" (
            builtins.readFile "${nix-lefthook-linter-coverage-full-src}/linter-coverage.awk"
          );
        in
        [
          (wrap "lefthook-git-conflict-markers" nix-lefthook-git-conflict-markers-src {
            runtimeInputs = [ pkgs.gnugrep ];
          })
          (wrap "lefthook-git-no-local-paths" nix-lefthook-git-no-local-paths-src {
            runtimeInputs = [ pkgs.gnugrep ];
          })
          (wrap "lefthook-missing-final-newline" nix-lefthook-missing-final-newline-src { })
          (pkgs.writeShellApplication {
            name = "lefthook-nix-no-embedded-shell";
            text = ''
              SCANNER="${nix-lefthook-nix-no-embedded-shell-src}/scan-nix-no-embedded-shell.sh"
            ''
            + builtins.readFile "${nix-lefthook-nix-no-embedded-shell-src}/lefthook-nix-no-embedded-shell.sh";
          })
          (wrap "lefthook-statix" nix-lefthook-statix-src {
            runtimeInputs = [ pkgs.statix ];
          })
          (wrap "lefthook-trailing-whitespace" nix-lefthook-trailing-whitespace-src {
            runtimeInputs = [ pkgs.gnugrep ];
          })
          (wrap "lefthook-deadnix" nix-lefthook-deadnix-src {
            runtimeInputs = [ pkgs.deadnix ];
          })
          (wrap "lefthook-editorconfig-checker" nix-lefthook-editorconfig-checker-src {
            runtimeInputs = [ pkgs.editorconfig-checker ];
          })
          (wrap "lefthook-nixfmt" nix-lefthook-nixfmt-src {
            runtimeInputs = [ pkgs.nixfmt ];
          })
          (wrap "lefthook-shellcheck" nix-lefthook-shellcheck-src {
            runtimeInputs = [ pkgs.shellcheck ];
          })
          (wrap "lefthook-shfmt" nix-lefthook-shfmt-src {
            runtimeInputs = [ pkgs.shfmt ];
          })
          (wrap "lefthook-typos" nix-lefthook-typos-src {
            runtimeInputs = [ pkgs.typos ];
          })
          (wrap "lefthook-yamllint" nix-lefthook-yamllint-src {
            runtimeInputs = [ pkgs.yamllint ];
          })
          (wrap "lefthook-gitleaks" nix-lefthook-gitleaks-src {
            runtimeInputs = [
              pkgs.gitleaks
              pkgs.coreutils
            ];
          })
          (wrap "lefthook-markdownlint-agentic" nix-lefthook-markdownlint-agentic-src {
            runtimeInputs = [ pkgs.markdownlint-cli ];
          })
          (wrap "lefthook-taplo" nix-lefthook-taplo-src {
            runtimeInputs = [ pkgs.taplo ];
          })
          (wrap "lefthook-bats-unit" nix-lefthook-bats-unit-src {
            runtimeInputs = [
              (batsWithLibsFor pkgs)
              pkgs.coreutils
            ];
          })
          (wrap "lefthook-actionlint" nix-lefthook-actionlint-src {
            runtimeInputs = [ pkgs.actionlint ];
          })
          (wrap "lefthook-bats-failures-only" nix-lefthook-bats-failures-only-src {
            runtimeInputs = [
              (batsWithLibsFor pkgs)
              pkgs.coreutils
            ];
          })
          (wrap "lefthook-bats-parse" nix-lefthook-bats-parse-src {
            runtimeInputs = [
              (batsWithLibsFor pkgs)
              pkgs.coreutils
            ];
          })
          (wrap "lefthook-changelog-touched" nix-lefthook-changelog-touched-src {
            runtimeInputs = [
              pkgs.git
              pkgs.diffutils
              pkgs.gnugrep
              pkgs.coreutils
            ];
          })
          (wrap "lefthook-commit-msg-lint" nix-lefthook-commit-msg-lint-src {
            runtimeInputs = [
              pkgs.gnused
              pkgs.coreutils
            ];
          })
          (wrap "lefthook-file-size-check" nix-lefthook-file-size-check-src {
            runtimeInputs = [
              pkgs.gawk
              pkgs.gnugrep
              pkgs.coreutils
              getFileSizeLimit
            ];
          })
          (pkgs.writeShellApplication {
            name = "lefthook-justfile-alphabetical";
            runtimeInputs = [
              pkgs.gawk
              pkgs.coreutils
            ];
            text = ''
              AWK_PROGRAM="${nix-lefthook-justfile-alphabetical-src}/justfile-alphabetical.awk"
            ''
            + builtins.readFile "${nix-lefthook-justfile-alphabetical-src}/lefthook-justfile-alphabetical.sh";
          })
          (wrap "lefthook-justfile-no-embedded-shell" nix-lefthook-justfile-no-embedded-shell-src { })
          (pkgs.writeShellApplication {
            name = "lefthook-linter-coverage-full";
            runtimeInputs = [
              pkgs.git
              pkgs.gawk
              pkgs.gnused
            ];
            text =
              builtins.replaceStrings [ "LEFTHOOK_LINTER_COVERAGE_AWK_PROGRAM_PATH" ] [ "${linterCoverageAwk}" ]
                (builtins.readFile "${nix-lefthook-linter-coverage-full-src}/lefthook-linter-coverage-full.sh");
          })
          (wrap "lefthook-narrow-language" nix-lefthook-narrow-language-src {
            runtimeInputs = [
              pkgs.coreutils
              pkgs.gnugrep
              pkgs.gnused
              pkgs.gawk
            ];
          })
          (wrap "lefthook-narrow-language-compact" nix-lefthook-narrow-language-src {
            runtimeInputs = [
              pkgs.coreutils
              pkgs.gnugrep
              pkgs.gnused
              pkgs.gawk
              pkgs.git
            ];
          })
          (wrap "lefthook-narrow-language-freeze" nix-lefthook-narrow-language-src {
            runtimeInputs = [
              pkgs.coreutils
              pkgs.gnugrep
              pkgs.gnused
              pkgs.git
            ];
          })
          (wrap "lefthook-narrow-language-suggest" nix-lefthook-narrow-language-src {
            runtimeInputs = [
              pkgs.coreutils
              pkgs.gnugrep
              pkgs.gnused
              pkgs.gawk
              pkgs.wordnet
            ];
          })
          (wrap "lefthook-narrow-language-add" nix-lefthook-narrow-language-src {
            runtimeInputs = [
              pkgs.coreutils
              pkgs.gnugrep
              pkgs.gnused
              pkgs.gawk
              pkgs.git
            ];
          })
          (wrap "lefthook-nix-flake-check" nix-lefthook-nix-flake-check-src {
            runtimeInputs = [ pkgs.nix ];
          })
          (wrap "lefthook-nix-flake-eval" nix-lefthook-nix-flake-eval-src {
            runtimeInputs = [
              pkgs.nix
              pkgs.coreutils
            ];
          })
          (wrap "lefthook-no-shell-functions" nix-lefthook-no-shell-functions-src { })
          (wrap "lefthook-pre-rebase-merged-commits" nix-lefthook-pre-rebase-merged-commits-src {
            runtimeInputs = [
              pkgs.git
              pkgs.gnugrep
              pkgs.coreutils
            ];
          })
          (pkgs.writeShellApplication {
            name = "lefthook-tdd-order-bats";
            runtimeInputs = [
              pkgs.git
              pkgs.gnused
              pkgs.diffutils
              pkgs.coreutils
            ];
            text =
              builtins.replaceStrings
                [ "@IS_EXCLUDED_PATH@" "@SPEC_PATH_FOR_FILE@" ]
                [
                  "${nix-lefthook-tdd-order-bats-src}/is-excluded-path.sh"
                  "${nix-lefthook-tdd-order-bats-src}/spec-path-for-file.sh"
                ]
                (builtins.readFile "${nix-lefthook-tdd-order-bats-src}/lefthook-tdd-order-bats.sh");
          })
          (wrap "lefthook-unicode-lint" nix-lefthook-unicode-lint-src {
            runtimeInputs = [
              pkgs.gnugrep
              pkgs.libiconv
              pkgs.python3
              pkgs.perl
            ];
          })
          (wrap "lefthook-unit-coverage" nix-lefthook-unit-coverage-src {
            runtimeInputs = [
              pkgs.git
              pkgs.taplo
              pkgs.coreutils
              pkgs.findutils
            ];
          })
        ];
    in
    {
      packages = forAllSystems (
        pkgs:
        {
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
            pkgs.taplo
            batsWithLibs
          ]
          ++ (lefthookWrappersFor pkgs);
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
