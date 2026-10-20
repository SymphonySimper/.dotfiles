{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dev.android;
in
{
  options.dev.android = {
    enable = lib.mkEnableOption "Android";
    studio.enable = lib.mkEnableOption "Android Studio";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [ pkgs.android-tools ];

        home.sessionVariables.ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
        home.sessionPath = [ "${config.home.sessionVariables.ANDROID_HOME}/emulator" ];

        dev.android.studio.enable = lib.mkDefault config.desktop.enable;
      }

      (lib.mkIf cfg.studio.enable {
        nixpkgs.config.allowUnfreePackages = [
          "android-cli"
          "android-studio"
        ];

        home.packages = [
          pkgs.android-cli
          pkgs.android-studio
        ];
      })
    ]
  );
}
