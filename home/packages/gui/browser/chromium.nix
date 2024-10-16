{
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  commandLineArgs = [ "--ozone-platform-hint=auto" ];
  mkDesktopEntry =
    {
      name,
      class,
      url,
    }:
    {
      inherit name;
      type = "Application";
      genericName = name;
      comment = "Launch ${name}";
      categories = [ "Application" ];
      terminal = false;
      exec = "chromium ${lib.strings.concatStringsSep " " commandLineArgs} --class=${class} --app=\"${url}\" %U";
      settings = {
        StartupWMClass = class;
      };
    };
  flavor = userSettings.theme.flavor;
  theme =
    if flavor == "frappe" then
      "olhelnoplefjdmncknfphenjclimckaf"
    else if flavor == "latte" then
      "jhjnalhegpceacdhbplhnakmkdliaddd"
    else if flavor == "macchiato" then
      "cmpdlhmnmjhihmcfnigoememnffkimlk"
    else
      "bkkmolkhemgaeaeggcmfbghljjjoofoh";
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
    extensions = [
      "${theme}" # Catppuccin theme
      # "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      # "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      # "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      # "edibdbjcniadpccecjdfdjjppcpchdlm" # i don't care about cookies
      # "bnclejfcblondkjliiblkojdeloomadd" # mute tab
    ];
    inherit commandLineArgs;
  };

  # Web Apps
  xdg.desktopEntries = {
    monkeytype = mkDesktopEntry rec {
      name = "monkeytype";
      class = name;
      url = "https://monkeytype.com/";
    };
    excalidraw = mkDesktopEntry rec {
      name = "excalidraw";
      class = name;
      url = "https://excalidraw.com/";
    };
  };
}
