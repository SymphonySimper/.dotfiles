{ userSettings, ... }:
{
  imports = [
    # ../../system/hardware/ideapad.nix
    # ../../system/packages/nvidia/enable.nix
    ../../system/default.nix
    ../../system/packages/steam.nix
    ../../system/pc.nix
    ./hardware.nix
  ] ++ (if userSettings.programs.wm then [
    ../../system/packages/hyprland.nix
  ] else [
    ../../system/packages/gnome.nix
  ]);

  services.xserver.videoDrivers = [ "amdgpu" ];
}
