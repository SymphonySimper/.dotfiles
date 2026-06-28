{ config, lib, ... }:
let
  cfg = config.my.hardware.audio;
in
{
  options.my.hardware.audio = {
    enable = lib.mkEnableOption "audio";
    programs.enable = lib.mkEnableOption "Programs";
  };

  config = lib.mkIf cfg.enable {
    # Enable sound with pipewire.
    # sound.enable = false;
    security.rtkit.enable = true;

    services = {
      pulseaudio.enable = false;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        # jack.enable = true;
      };
    };
  };
}
