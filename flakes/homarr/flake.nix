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
            pkgs.gnused
          ];

          pnpmDeps = fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            pnpm = pnpm;
            nodejs = nodejs;
            fetcherVersion = 3;
            hash = "sha256-GVjNQ3uS4K5AhWbJFlghHiaHjReaQjdOJJxfFLehLlM=";
          };
          # Build Homarr
          # buildPhase = ''

          #   # Copy pre-fetched node_modules
          #   mkdir -p node_modules
          #   cp -r ${pnpmDeps}/node_modules/* node_modules/

          # '';

          # pnpmInstallFlags = [ "--shamefully-hoist" ];

          # postPatch = ''
          #   echo "Copying vendored package-lock.json..."
          #   cp ${./etc.sh} etc.sh
          # '';

          # buildPhase = ''
          #   # cp ./.env.example ./.env
          #   # mkdir -p ./db
          #   # sed -i "s|FULL_PATH_TO_YOUR_SQLITE_DB_FILE|$self/db/homarr.sqlite3|" ./.env
          #   # touch ./db/homarr.sqlite3
          # '';

          # postPatch = ''
          #   mkdir -p db
          #   cp ${./homarr.sqlite} ./db/homarr.sqlite3
          #   chmod +w ./db/homarr.sqlite3
          #   cp ${./etc.sh} etc.sh
          # '';

          installPhase = ''
            # Install built app to $out
            mkdir -p $out
            cp -r . $out
            # # mkdir -p $out/db
            # cp $out/.env.example $out/.env
            # # pnpm run db:migration:sqlite:run
            # pnpm build
            # mv $out/.env $out/homarr.env
            # mkdir -p build
            # cp $out/node_modules/better-sqlite3/build/Release/better_sqlite3.node $out/build/better_sqlite3.node
            # sed -i "s|$out/db/homarr.sqlite3|/var/lib/homarr/homarr.sqlite3" $out/homarr.env
            # # # touch $out/db/homarr.sqlite3
            # # # pnpm run db:migration:sqlite:run
            # sed -i  's|outfile=|outfile=/etc/homarr/|' $out/apps/tasks/package.json $out/apps/websocket/package.json $out/packages/cli/package.json $out/packages/db/package.json
            # sed -i  's|out: "\./|out: "/var/lib/homarr/|' $out/packages/db/configs/mysql.config.ts $out/packages/db/configs/postgresql.config.ts $out/packages/db/configs/sqlite.config.ts
            # sed -i  's|dotenv -e ../../.env --|dotenv -e /etc/homarr/homarr.env --|' $out/apps/tasks/package.json $out/apps/nextjs/package.json $out/apps/websocket/package.json $out/packages/db/package.json 
            # sed -i  's|dotenv -e .env --|dotenv -e /etc/homarr/homarr.env --|' $out/package.json 
          '';

          # installPhase = ''
          #   # Install built app to $out
          #   mkdir -p $out
          #   cp -r . $out
          #   # pnpm -C $out install
          #   # pnpm -C $out approve-builds -g
          #   cp $out/.env.example $out/.env
          #   touch $out/homarr.sqlite
          #   sed -i "s|FULL_PATH_TO_YOUR_SQLITE_DB_FILE|$out/homarr.sqlite|" $out/.env
          #   echo sed -i  "s|FULL_PATH_TO_YOUR_SQLITE_DB_FILE|$out/homarr.sqlite|" $out/.env
          #   cp $out/.env ./.env
          #   pnpm run db:migration:sqlite:run
          #   mkdir -p $out/build
          #   cp $out/node_modules/better-sqlite3/build/Release/better_sqlite3.node $out/build/better_sqlite3.node
          # '';

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
