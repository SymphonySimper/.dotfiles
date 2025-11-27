{ config, pkgs, ... }:
{
  # Add Google Chrome
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.concatStringsSep " " config.my.programs.browser.args.chromium;
    })
  ];
}
