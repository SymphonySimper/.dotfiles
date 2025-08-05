{ config, pkgs, ... }:
{
  # Add Google Chrome
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.concatStringsSep " " config.my.programs.browser.chromiumArgs;
    })
  ];

  my.programs.desktop = {
    windows = [
      {
        id = "google-chrome";
        workspace = 3;
        silent = true;
      }
    ];
  };

  # wayland.windowManager.hyprland.settings = {
  #   # https://github.com/ValveSoftware/gamescope/issues/1825
  #   # https://github.com/hyprwm/Hyprland/issues/9064
  #   debug.full_cm_proto = true;
  # };
}
