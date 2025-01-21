{
  config,
  lib,
  ...
}:
{
  options.my.programs.android = {
    enable = lib.mkEnableOption "Android";
  };

  config = lib.mkIf config.my.programs.android.enable {
    my.user.groups = [
      "kvm" # for emulators
      "adbusers"
    ];

    programs.adb.enable = true;
    services.gvfs.enable = true;
  };
}
