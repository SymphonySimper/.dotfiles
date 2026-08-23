{ config, lib, ... }:
let
  cfg = config.hardware.audio;
in
{
  options.hardware.audio = {
    enable = lib.mkEnableOption "Audio";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
