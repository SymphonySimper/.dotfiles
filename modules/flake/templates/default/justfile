set quiet := true

greet:
    @echo "Hello from Just!"

update-flake:
    nix --option commit-lockfile-summary "chore(flake): update flake.lock" flake update --commit-lock-file
