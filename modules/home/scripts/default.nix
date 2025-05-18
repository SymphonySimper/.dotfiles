{ config, lib, ... }:
let
  cfg = config.my.programs.scripts;
in
{
  imports = [
    ./ffmpeg.nix
    ./log.nix
    ./ocr.nix
    ./reload.nix
  ];

  options.my.programs.scripts.enable = lib.mkEnableOption "Scripts";

  config = {
    my.programs.scripts.reload.enable = lib.mkDefault cfg.enable;
  };
}
