{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home
  ];

  # Add Google Chrome
  my.desktop.windows = [
    {
      id = "google-chrome";
      workspace = 3;
    }
  ];

  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.concatStringsSep " " config.my.programs.browser.chromiumArgs;
    })
  ];
}
