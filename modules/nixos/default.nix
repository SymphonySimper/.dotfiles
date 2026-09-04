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
    ./users.nix
    ./wsl.nix
    ./sudo.nix
  ];

  system.stateVersion = "25.11";
}
