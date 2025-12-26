switch-flake:
	git pull
	# git commit -am "Building new system"
	# git push
	sudo nixos-rebuild switch --upgrade --flake ./#whowhatetc

flake-check:
	nix flake check

