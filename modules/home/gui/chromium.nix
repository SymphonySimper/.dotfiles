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

  mkDesktopEntries =
    entries:
    builtins.listToAttrs (
      builtins.map (
        entry:
        let
          name = builtins.elemAt entry 0;
          class = name;
          url = builtins.elemAt entry 1;
          app = if builtins.length entry == 3 then builtins.elemAt entry 2 else true;
          urlArg = if app then "--app=" else "";
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
            exec = "${lib.getExe config.programs.chromium.package} ${lib.strings.concatStringsSep " " commandLineArgs} --class=${class} ${urlArg}\"${url}\" %U";
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
        false
      ]
      [
        "whatsapp"
        "https://web.whatsapp.com/"
        false
      ]
      [
        "lichess"
        "https://lichess.org/"
        false
      ]
    ]
    ++ (lib.optionals (my.programs.music == "yt") [
      [
        "ytmusic"
        "https://music.youtube.com/"
        false
      ]
    ])

  );
}
