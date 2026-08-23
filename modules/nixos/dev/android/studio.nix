{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dev.android.studio;
in
{
  options.dev.android.studio = {
    enable = lib.mkEnableOption "Android Studio";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePackages = [ "android-studio" ];

    users.groups.kvm.members = config.users.groups.wheel.members; # for emulators
    environment.systemPackages = [ pkgs.android-studio ];
  };
}
