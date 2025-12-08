{ config, lib, ... }:
let
  cfg = config.my.programs.scripts;
in
{
  imports = [
    ./ffmpeg.nix
    ./ocr.nix
  ];

  options.my.programs.scripts.enable = (lib.mkEnableOption "Scripts") // {
    default = true;
  };

  config = {
    my.programs.scripts = {
      ffmpeg.enable = lib.mkDefault cfg.enable;
      ocr.enable = lib.mkDefault cfg.enable;
    };
  };
}
