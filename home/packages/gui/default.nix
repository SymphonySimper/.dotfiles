{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    # ./hyprland/default.nix
    ./media.nix
    ./theme.nix
    ./wezterm/default.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    firefox
  ];
}
