{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.android;
in
{
  options.my.programs.android = {
    enable = lib.mkEnableOption "Android";
  };

  config = (
    lib.mkIf cfg.enable {
      my.user.groups = [
        "kvm" # for emulators
        "adbusers"
      ];

      programs.adb.enable = true;
      services.gvfs.enable = true;

      environment.systemPackages = [
        (pkgs.android-studio.override { forceWayland = config.my.programs.desktop.enable; })
      ];
    }
  );
}
