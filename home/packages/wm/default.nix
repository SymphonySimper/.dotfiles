{ userSettings, pkgs, ... }:
{
  imports = (
    if userSettings.programs.wm then
      [
        # ./hyprland.nix
        # ./river.nix
        ./sway.nix
        ./utils/default.nix
        ./scripts/default.nix
      ]
    else
      [ ]
  );

  home.packages = (if userSettings.programs.wm then with pkgs; [ nautilus ] else [ ]);
}
