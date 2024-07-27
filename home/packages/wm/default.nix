{ pkgs, ... }:
{
  imports = [
    # ./hyprland.nix
    # ./river.nix
    ./sway.nix
    ./utils/default.nix
  ];

  home.packages = with pkgs; [
    nautilus
    swaybg
    # hyprshot
  ];
}
