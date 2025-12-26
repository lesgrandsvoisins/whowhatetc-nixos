{
  description = "Dashy dashboard packaged with buildNpmPackage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages.default = pkgs.buildNpmPackage (finalAttrs: {
          pname = "dashy";
          version = "3.1.1";

          src = pkgs.fetchFromGitHub {
            owner = "Lissy93";
            repo = "dashy";
            tag = "v${finalAttrs.version}";
            # First build will fail and print `got:` — paste that here
            hash = ""; 
          };

          # Nix prints this during second build — paste the value here
          npmDepsHash = "";

          # dashy has engine requirements, so bypass them
          npmPackFlags = [ "--ignore-engines" ];
          NODE_OPTIONS = "--ignore-engines";

          meta = {
            description = "Dashy, a modernish dashboard";
            homepage = "https://dashy.to/";
            license = pkgs.lib.licenses.mit;
          };
        });

        # allows `nix develop` → run / modify dashy
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
            pkgs.nodePackages.npm
          ];
        };
      }
    );
}
