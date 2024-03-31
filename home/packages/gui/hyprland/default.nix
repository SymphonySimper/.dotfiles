{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    systemd.enable = true;
    xwayland.enable = true;
  };

  home.packages = with pkgs; [
    waybar
    hyprshot
    hyprpaper
  ];

  xdg.configFile."hypr" = {
    source = ./config;
    recursive = true;
  };
}
