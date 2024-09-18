{ pkgs, ... }:
{
  imports = [
    ./mpv.nix
    ./spotify.nix
  ];

  programs.obs-studio.enable = true;

  home.packages = with pkgs; [
    qbittorrent
  ];
}
