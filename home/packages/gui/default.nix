{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./hyprland/default.nix
    ./theme.nix
    ./wezterm/default.nix
  ];

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    firefox
  ];
}
