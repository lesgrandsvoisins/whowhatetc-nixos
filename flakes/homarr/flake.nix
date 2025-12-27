{
  description = "Homarr Dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_25;
        pnpm = pkgs.pnpm_10.override { nodejs = nodejs; };
        fetchPnpmDeps = pkgs.fetchPnpmDeps;
        stdenv = pkgs.stdenv;
        pnpmConfigHook = pkgs.pnpmConfigHook;
      in
      {
        packages.default = stdenv.mkDerivation (finalAttrs: {
          pname = "homarr";
          version = "1.48.0";

          src = pkgs.fetchFromGitHub {
            owner = "homarr-labs";
            repo = "homarr";
            tag = "v${finalAttrs.version}";
            hash = "sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g="; 
          };

          nativeBuildInputs = [
            pnpm
            nodejs
            pnpmConfigHook
          ];

          pnpmDeps = fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            pnpm = pnpm;
            nodejs = nodejs;
            fetcherVersion = 3;
            hash = "sha256-fh599IyeF0EUlyyvinDiaq/qsJB3Zdp1WQ2iYr2L/GM=";
          };
          # Build Homarr
          # buildPhase = ''

          #   # Copy pre-fetched node_modules
          #   mkdir -p node_modules
          #   cp -r ${pnpmDeps}/node_modules/* node_modules/

          # '';

          # pnpmInstallFlags = [ "--shamefully-hoist" ];


          installPhase = ''
            # Install built app to $out
            mkdir -p $out
            cp -r . $out
            pnpm -C $out install
            pnpm -C $out approve-builds -g
            cp ./.env $out/.env'
            echo "DB_URL='$out/homarr.sqlite'" >> $out/.env
            pnpm run db:migration:sqlite:run
            mkdir -p $out/build
            cp $out/node_modules/better-sqlite3/build/Release/better_sqlite3.node $out/build/better_sqlite3.node
          '';

          meta = {
            description = "Homarr, a modernish dashboard";
            homepage = "https://homarr.dev/";
          };
        });

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pnpm
            nodejs
          ];
        };
      }
    );
}
