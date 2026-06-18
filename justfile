set quiet

hostname := `hostname`

[private]
git-track-worktree FOR:
    git update-index --no-skip-worktree overrides/{{ FOR }}.nix

[private]
git-untrack-worktree FOR:
    git update-index --skip-worktree overrides/{{ FOR }}.nix

[group('build')]
[linux]
build-system HOST=hostname: (git-track-worktree "system") && (git-untrack-worktree "system")
    sudo nixos-rebuild switch --flake .#{{ HOST }}

[group('build')]
[unix]
build-home HOST=hostname: (git-track-worktree "home") && (git-untrack-worktree "home")
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

[group('scripts')]
[windows]
update-config:
    python ./scripts/windows/update-config.py
