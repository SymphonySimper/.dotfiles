{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home
  ];

  # Add Google Chrome
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.concatStringsSep " " config.my.programs.browser.chromiumArgs;
    })
  ];

  my.desktop = {
    autostart = [
      {
        name = "google-chrome";
        cmd = "google-chrome-stable";
        days = [1 2 3 4 5];
      }
    ];

    windows = [
      {
        id = "google-chrome";
        workspace = 3;
        silent = true;
      }
    ];
  };
}
