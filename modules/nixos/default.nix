{ ... }: {
  imports = [
    ../common

    ./hardware
    ./networking
    ./programs
    ./virtualisation

    ./boot.nix
    ./desktop.nix
    ./localisation.nix
    ./nix.nix
    ./wsl.nix
    ./sudo.nix
  ];

  users.mutableUsers = true;

  system.stateVersion = "25.11";
}
