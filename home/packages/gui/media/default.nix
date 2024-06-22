{ pkgs, ... }: {
  imports = [
    ./mpv.nix
  ];

  programs.obs-studio.enable = true;

  home.packages = with pkgs; [
    spotify
    qbittorrent
    # discord
  ];
}
