{ pkgs, ... }:
{
  imports = [
    # ./hyprland.nix
    # ./river.nix
    ./sway.nix
    ./utils/default.nix
    ./scripts/default.nix
  ];

  home.packages = with pkgs; [
    foliate
    loupe
    nautilus
  ];
}
