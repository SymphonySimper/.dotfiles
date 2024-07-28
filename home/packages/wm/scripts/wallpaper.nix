{ userSettings, pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "wallpaper" ''
      ${pkgs.swaybg}/bin/swaybg -i "${userSettings.wallpaper}" -m fill
    '')
  ];
}
