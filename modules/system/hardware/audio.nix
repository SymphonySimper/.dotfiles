{
  pkgs,
  lib,
  config,
  my,
  ...
}:
let
  cfg = config.my.hardware.audio;
in
{
  options.my.hardware.audio = {
    enable = lib.mkEnableOption "audio";
  };
  config = lib.mkIf cfg.enable {
    # Enable sound with pipewire.
    # sound.enable = false;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
    environment.defaultPackages = lib.mkIf my.gui.desktop.enable (
      with pkgs;
      [
        helvum
        pavucontrol
      ]
    );
  };
}
