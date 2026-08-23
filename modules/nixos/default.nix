{ ... }: {
  imports = [
    ../common

    ./dev
    ./hardware
    ./networking
    ./programs
    ./theme
    ./virtualisation

    ./boot.nix
    ./desktop.nix
    ./fhs.nix
    ./locale.nix
    ./nix.nix
    ./shell.nix
    ./timezone.nix
    ./users.nix
    ./wsl.nix
    ./sudo.nix
  ];

  system.stateVersion = "25.11";
}
