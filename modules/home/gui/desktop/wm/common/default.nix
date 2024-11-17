{ pkgs, ... }:
{
  imports = [
    ./scripts/default.nix
    ./utils/default.nix
    ./xdg/default.nix
  ];

  targets.genericLinux.enable = false;
  services.gnome-keyring.enable = true;

  home.packages = with pkgs; [
    nautilus
  ];
}
