{
  userSettings,
  config,
  pkgs,
  ...
}:
let
  theme = if userSettings.theme.dark then "dark" else "light";
  wallpapers = "${config.xdg.dataHome}/wallpapers/${theme}";
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
