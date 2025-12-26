{
  lib,
  buildNpmPackage,
  fetchFromGitHub
}:

pkgs.buildNpmPackage (finalAttrs: {
  pname = "dashy";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "dashy";
    tag = "v${finalAttrs.version}";
    hash = "";
  };

  npmDepsHash = "";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-engines" ];

  NODE_OPTIONS = "--ignore-engines";

  meta = {
    description = "Dashy, a modernish dashboard";
    homepage = "https://dashy.to/";
  };
})