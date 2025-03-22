{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;

    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };
}
