{ ... }: {
  imports = [
    ../common

    ./hardware
    ./networking
    ./programs
    ./virtualisation

    ./boot.nix
    ./desktop.nix
    ./fhs.nix
    ./localisation.nix
    ./nix.nix
    ./shell.nix
    ./wsl.nix
    ./sudo.nix
  ];

  users.mutableUsers = true;

  system.stateVersion = "25.11";
}
