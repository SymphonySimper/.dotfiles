set quiet := true

hostname := `hostname`

[group('build')]
[linux]
build-system HOST=hostname:
    sudo nixos-rebuild switch --flake .#{{ HOST }}

[group('build')]
[unix]
build-home HOST=hostname:
    home-manager build switch --flake .#{{ HOST }}

[group('clean')]
[linux]
clean-system:
    sudo nix-collect-garbage -d

[group('clean')]
[unix]
clean-home:
    nix-collect-garbage -d

[group('clean')]
[linux]
clean: clean-system clean-home

[unix]
last-week-commits:
    ./scripts/flake-last-week-commits.sh

[unix]
news-home HOST=hostname:
    home-manager news --flake .#{{ HOST }}

[unix]
update-flake:
    nix flake update --commit-lock-file

[linux]
gnome-nested-shell:
    SHELL_DEBUG=all dbus-run-session gnome-shell --devkit --wayland

[group('generators')]
[unix]
generate-theme-colors:
    nu ./scripts/generators/theme-colors.nu
