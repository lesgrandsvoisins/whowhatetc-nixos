install:
	git clone https://github.com/homarr-labs/homarr.git
	pnpm -C ./homarr install
	cp ./homarr/.env{.example,}
	sed -i 's|FULL_PATH_TO_YOUR_SQLITE_DB_FILE|/home/homarr/homarr/homarr.sqlite3|' ./homarr/.env
	RAND=`openssl rand -hex 32`; sed -i "s|0000000000000000000000000000000000000000000000000000000000000000|${RAND}|"  ./homarr/.env
	RAND=`openssl rand -hex 32`; sed -i "s|supersecret|${RAND}|"  ./homarr/.env
	RAND=`openssl rand -base64 32`; sed -i "s|your-generated-api-key|${RAND}|"  ./homarr/.env
	pnpm -C ./homarr run db:migration:sqlite:run
	pnpm -C ./homarr build
	mkdir ./homarr/build
	cp ./homarr/node_modules/better-sqlite3/build/Release/better_sqlite3.node ./homarr/build/better_sqlite3.node
	# redis-server
	pnpm -C ./homarr start