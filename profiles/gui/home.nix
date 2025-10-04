{ config, pkgs, ... }:
{
  # Add Google Chrome
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.concatStringsSep " " config.my.programs.browser.chromiumArgs;
    })
  ];

  my.programs = {
    desktop = {
      windows = [
        {
          id = "google-chrome";
          workspace = 3;
          silent = true;
        }
      ];
    };

    media = {
      video.enable = true;
      recorder.enable = false;
    };
  };
}
