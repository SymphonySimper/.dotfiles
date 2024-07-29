{
  userSettings,
  config,
  pkgs,
  ...
}:
let
  wallpapers = "${config.xdg.dataHome}/wallpapers";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "wallpaper" ''
      wallpaper="${userSettings.wallpaper}"

      if [ -d "${wallpapers}" ]; then
        file="$(command ls ${wallpapers} | grep -v -E "(\.py|\.git)$" |  sort -R | head -n1)"

        if [ -n "$file" ]; then
          wallpaper="${wallpapers}/$file"
        fi
      fi

      ${pkgs.swaybg}/bin/swaybg -i "$wallpaper" -m fill;
    '')
  ];
}
