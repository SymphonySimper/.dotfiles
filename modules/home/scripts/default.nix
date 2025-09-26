{ config, lib, ... }:
let
  cfg = config.my.programs.scripts;
in
{
  imports = [
    ./ffmpeg.nix
    ./ocr.nix
    ./reload.nix
    ./todo.nix
  ];

  options.my.programs.scripts.enable = lib.mkEnableOption "Scripts";

  config = {
    my.programs.scripts = {
      ffmpeg.enable = lib.mkDefault cfg.enable;
      ocr.enable = lib.mkDefault cfg.enable;
      reload.enable = lib.mkDefault cfg.enable;
      todo.enable = lib.mkDefault cfg.enable;
    };
  };
}
