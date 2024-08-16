{ userSettings, ... }:
{
  imports =
    if userSettings.desktop.name == "hyprland" then
      [
        # ./hyprpaper.nix
        # ./waybar.nix
        ./hyprland.nix
      ]
    else
      [ ];
}
