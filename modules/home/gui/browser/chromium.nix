{
  my,
  pkgs,
  lib,
  ...
}:
let
  theme = {
    frappe = "olhelnoplefjdmncknfphenjclimckaf";
    latte = "jhjnalhegpceacdhbplhnakmkdliaddd";
    macchiato = "cmpdlhmnmjhihmcfnigoememnffkimlk";
    mocha = "bkkmolkhemgaeaeggcmfbghljjjoofoh";
  };

  features = {
    disable = [ "WebRtcAllowInputVolumeAdjustment" ];
    enable = [
      # https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration
      "AcceleratedVideoDecodeLinuxGL"

      # https://wiki.archlinux.org/title/Chromium#Vulkan
      "VaapiVideoDecoder"
      "VaapiIgnoreDriverChecks"
      "Vulkan"
      "DefaultANGLEVulkan"
      "VulkanFromANGLE"
    ];
  };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;

    commandLineArgs =
      [
        # "--ozone-platform-hint=auto"
      ]
      ++ (builtins.map
        (feature: "--${feature.name}-features=${builtins.concatStringsSep "," feature.value}")
        (
          builtins.filter (f: (builtins.length f.value) > 0) (
            lib.attrsets.mapAttrsToList (name: value: { inherit name value; }) features
          )
        )
      );

    extensions = [
      theme.${my.theme.flavor} # Catppuccin theme
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
  };
}
