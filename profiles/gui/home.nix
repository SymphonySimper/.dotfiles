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
      automove = [
        {
          name = "google-chrome.desktop";
          workspace = 2;
        }
      ];
    };

    media.recorder.enable = false;
  };
}
