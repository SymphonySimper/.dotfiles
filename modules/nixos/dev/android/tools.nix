{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dev.android.tools;
in
{
  options.dev.android.tools = {
    enable = lib.mkEnableOption "Tools";
  };

  config = lib.mkIf cfg.enable {
    users.groups.adbusers.members = config.users.groups.wheel.members;
    services.gvfs.enable = true;
    environment.systemPackages = [ pkgs.android-tools ];
  };
}
