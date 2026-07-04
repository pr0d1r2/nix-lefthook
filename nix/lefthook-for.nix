{ version }:
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
}
