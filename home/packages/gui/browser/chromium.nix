{
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  commandLineArgs = [ "--ozone-platform-hint=auto" ];
  mkDesktopEntries =
    entries:
    builtins.listToAttrs (
      builtins.map (
        entry:
        let
          name = builtins.elemAt entry 0;
          class = name;
          url = builtins.elemAt entry 1;
        in
        {
          inherit name;
          value = {
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
        }
      ) entries
    );
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
  xdg.desktopEntries = mkDesktopEntries (
    [
      [
        "monkeytype"
        "https://monkeytype.com/"
      ]
      [
        "excalidraw"
        "https://excalidraw.com/"
      ]
    ]
    ++ (
      if userSettings.programs.music == "yt" then
        [
          [
            "youtubemusic"
            "https://music.youtube.com/"
          ]
        ]
      else
        [ ]
    )
  );
}
