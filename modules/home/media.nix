{ config, lib, ... }:
let
  cfg = config.my.programs.media;
in
{
  options.my.programs.media = {
    enable = lib.mkEnableOption "Media";
    recorder.enable = lib.mkEnableOption "Recorder";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        my.programs = {
          media = {
            recorder.enable = lib.mkDefault false;
          };
        };
      }

      (lib.mkIf cfg.recorder.enable {
        programs.obs-studio.enable = true;

        my.programs.desktop.automove = [
          {
            name = "com.obsproject.Studio.desktop";
            workspace = 5;
          }
        ];
      })
    ]
  );
}
