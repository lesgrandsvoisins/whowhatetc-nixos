switch-flake:
	git pull
	# git commit -am "Building new system"
	# git push
	sudo nixos-rebuild switch --upgrade --flake ./#whowhatetc

flake-check:
	nix flake check

take-out-the-old-garbage:
	nix-collect-garbage --delete-older-than 7d
	nix-store --gc