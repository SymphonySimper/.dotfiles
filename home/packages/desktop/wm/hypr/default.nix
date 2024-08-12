{ userSettings, ... }:
{
  imports =
    if userSettings.desktop.name == "hyprland" then
      [
        # ./hyprpaper.nix
        ./hyprland.nix
        ./waybar.nix
      ]
    else
      [ ];
}
