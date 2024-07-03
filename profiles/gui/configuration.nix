{ userSettings, ... }:
{
  imports = [
    ../../system/default.nix
    ../../system/hardware/ideapad.nix
    ../../system/packages/nvidia/enable.nix
    ../../system/packages/steam.nix
    ../../system/pc.nix
    ./hardware.nix
  ] ++ (if userSettings.programs.wm then [
    ../../system/packages/hyprland.nix
  ] else [
    ../../system/packages/gnome.nix
  ]);
}
