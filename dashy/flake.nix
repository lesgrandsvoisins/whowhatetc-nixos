{
  description = "Dashy dashboard packaged with buildNpmPackage (lambda style)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.buildNpmPackage (finalAttrs: {
          pname = "dashy";
          version = "3.1.1";

          src = pkgs.fetchFromGitHub {
            owner = "Lissy93";
            repo = "dashy";
            tag = "${finalAttrs.version}";
            hash = "sha256-ci4YlxFNp+JD5EzYfhtM9jKy5fl+a48vp9QzZHh5NRg=";
          };

          # Second build will fail -> paste 'got:' here
          npmDepsHash = "sha256-3Fab/pfAQd0O10U7FQjfJP79zIR3ubn+CfEY/ujxFMc=";

          # Dashy has engine checks we want to ignore
          npmPackFlags = [ "--legacy-peer-deps" "--ignore-engines" ];
          # NODE_OPTIONS = "";
          npmFlags = [ "--legacy-peer-deps" "--ignore-engines"];
          makeCacheWritable = true;

          # Inject your local package-lock.json
          postPatch = ''
            echo "Copying vendored package-lock.json..."
            cp ${./package-lock.json} package-lock.json
          '';

          meta = {
            description = "Dashy, a modernish dashboard";
            homepage = "https://dashy.to/";
            license = pkgs.lib.licenses.mit;
          };
        });

        # Optional: dev shell
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
            pkgs.nodePackages.npm
          ];
        };
      }
    );
}
