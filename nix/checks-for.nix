{ lefthookWrappersFor }:
pkgs:
let
  wrappers = lefthookWrappersFor pkgs;
  wrapperNames = builtins.concatStringsSep " " (map (w: w.name) wrappers);
in
{
  wrappers = pkgs.runCommand "check-wrappers" {
    nativeBuildInputs = wrappers ++ [ pkgs.bash ];
    WRAPPER_NAMES = wrapperNames;
  } (builtins.readFile ./checks-wrappers.sh);
}
