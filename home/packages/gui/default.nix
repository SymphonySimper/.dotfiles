{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./alacritty.nix
    ./wezterm/default.nix
  ];

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
