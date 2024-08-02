{
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  commandLineArgs = [ "--ozone-platform-hint=auto" ];
  mkDesktopFile =
    {
      name,
      class,
      url,
    }:
    {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=${name}
        StartupWMClass=${class}
        Comment=Launch ${name}
        Exec=chromium ${lib.strings.concatStringsSep " " commandLineArgs} --class=${class} --app="${url}" %U
        Terminal=false
      '';
      target = "${userSettings.home}/.local/share/applications/${name}.desktop";
    };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "bkkmolkhemgaeaeggcmfbghljjjoofoh" # Catppuccin mocha
      "mjdepdfccjgcndkmemponafgioodelna" # df youtube
      "edibdbjcniadpccecjdfdjjppcpchdlm" # i don't care about cookies
      "jpbjcnkcffbooppibceonlgknpkniiff" # global speed
      "bnclejfcblondkjliiblkojdeloomadd" # mute tab
    ];
    inherit commandLineArgs;
  };

  # Web Apps
  home.file."monkeytype.desktop" = mkDesktopFile {
    name = "monkeytype";
    class = "monkeytype";
    url = "https://monkeytype.com/";
  };
}
