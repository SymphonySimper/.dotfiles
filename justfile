set quiet := true

hostname := `hostname`

[group('build')]
build-system HOST=hostname:
    sudo nixos-rebuild switch --flake .#{{ HOST }}

[group('build')]
build-home HOST=hostname:
    home-manager build switch --flake .#{{ HOST }}

[group('clean')]
clean-system:
    sudo nix-collect-garbage -d

[group('clean')]
clean-home:
    nix-collect-garbage -d

[group('clean')]
clean: clean-system clean-home
