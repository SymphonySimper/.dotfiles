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
  ];

  users.mutableUsers = true;

  documentation.doc.enable = false; # HTML manual, nixos-help and the package docs
  documentation.info.enable = false; # Info pages and the info command

  system.stateVersion = "25.11";
}
