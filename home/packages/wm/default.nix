{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./waybar/default.nix
  ];

  home.packages = with pkgs; [
    dunst
    gnome.nautilus
    hyprshot
    wofi
  ];
}
