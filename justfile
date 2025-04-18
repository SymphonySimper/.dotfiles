set quiet := true

hostname := `hostname`

build-system HOST=hostname:
    sudo nixos-rebuild switch --flake .#{{ HOST }}

build-home HOST=hostname:
    home-manager build switch --flake .#{{ HOST }}
