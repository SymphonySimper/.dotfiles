{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePackages = [
    "chromium"
    "chromium-unwrapped"
    "widevine-cdm"
  ];

  catppuccin.chromium.enable = false;

  programs.chromium = lib.mkIf config.programs.chromium.enable {
    package = pkgs.chromium.override { enableWideVine = true; };

    commandLineArgs =
      map (feature: "--${feature.name}-features=${builtins.concatStringsSep "," feature.value}")
        (
          builtins.filter (f: (builtins.length f.value) > 0) (
            lib.attrsets.mapAttrsToList (name: value: { inherit name value; }) {
              disable = [ "WebRtcAllowInputVolumeAdjustment" ];

              enable = [
                # https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration
                "AcceleratedVideoDecodeLinuxGL"
                "AcceleratedVideoEncoder"
              ];
            }
          )
        );
  };
}
