{ ... }: {
  imports = [
    ../common

    ./desktop
    ./dev
    ./programs
    ./scripts
    ./theme
    ./xdg

    ./copy.nix
    ./user.nix
    ./wsl.nix
  ];

  programs.home-manager.enable = true; # Required for standalone usage
  home.stateVersion = "25.11"; # Do not change
}
