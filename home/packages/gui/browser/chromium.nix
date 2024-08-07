{
  lib,
  pkgs,
  userSettings,
  config,
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
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "mjdepdfccjgcndkmemponafgioodelna" # df youtube
      "edibdbjcniadpccecjdfdjjppcpchdlm" # i don't care about cookies
      "jpbjcnkcffbooppibceonlgknpkniiff" # global speed
      "bnclejfcblondkjliiblkojdeloomadd" # mute tab
      "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture
    ];
    inherit commandLineArgs;
  };

  # Web Apps
  xdg.desktopEntries = {
    monkeytype = mkDesktopEntry {
      name = "monkeytype";
      class = "monkeytype";
      url = "https://monkeytype.com/";
    };
  };
}
