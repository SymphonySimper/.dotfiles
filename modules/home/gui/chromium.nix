{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  commandLineArgs = [
    "--ozone-platform-hint=auto"
    "--disable-features=WebRtcAllowInputVolumeAdjustment"
  ];

  browsers = {
    chromium = lib.getExe config.programs.chromium.package;
  };

  mkDesktopEntries =
    entries:
    builtins.listToAttrs (
      builtins.map (
        entry:
        let
          name = entry.name;
          class = name;
          url = entry.url;
          app = lib.my.mkGetDefault entry "app" false;
          urlArg = if app then "--app=" else "";
          exe = lib.my.mkGetDefault entry "exe" browsers.chromium;
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
            exec = "${exe} ${lib.strings.concatStringsSep " " commandLineArgs} --class=${class} ${urlArg}\"${url}\" %U";
            settings = {
              StartupWMClass = class;
            };
          };
        }
      ) entries
    );
  flavor = my.theme.flavor;
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
    package = pkgs.google-chrome;
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

  # # Web Apps
  # xdg.desktopEntries = mkDesktopEntries (
  #   [
  #     {
  #       name = "monkeytype";
  #       url = "https://monkeytype.com/";
  #       app = true;
  #     }
  #     {
  #       name = "excalidraw";
  #       url = "https://excalidraw.com/";
  #     }
  #     {
  #       name = "whatsapp";
  #       url = "https://web.whatsapp.com/";
  #     }
  #     {
  #       name = "lichess";
  #       url = "https://lichess.org/";
  #     }
  #   ]
  #   ++ (lib.optionals (my.programs.music == "yt") [
  #     {
  #       name = "ytmusic";
  #       url = "https://music.youtube.com/";
  #     }
  #   ])
  # );
}
