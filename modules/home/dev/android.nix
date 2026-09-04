{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.android = {
    enable = lib.mkEnableOption "Android";
  };

  config = lib.mkIf config.dev.android.enable {
    nixpkgs.config.allowUnfreePackages = [ "android-studio" ];

    home.packages = [ pkgs.android-studio ];
  };
}
