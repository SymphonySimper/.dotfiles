{ ... }: {
  imports = [
    ./desktop
    ./dev
    ./programs
    ./scripts
    ./theme
    ./xdg

    ./user.nix
    ./wsl.nix
  ];

  programs.home-manager.enable = true; # Required for standalone usage
  home.stateVersion = "25.11"; # Do not change
}
