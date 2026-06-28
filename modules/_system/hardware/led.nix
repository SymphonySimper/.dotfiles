{
  lib,
  config,
  ...
}:
{
  options.my.hardware.led = {
    enable = lib.mkEnableOption "Led";
  };
  config = lib.mkIf config.my.hardware.led.enable {
    # source: https://codeberg.org/AndrewKvalheim/configuration/src/branch/main/hosts/main/system.nix#:~:text=systemd.services,%7D%3B
    # refer:  https://discourse.nixos.org/t/why-does-the-sound-automatically-mute-when-an-led-is-turned-on/20480
    systemd.services.turnoff-sound-leds = rec {
      wantedBy = [ "sound.target" ];
      after = wantedBy;
      serviceConfig.Type = "oneshot";
      script = ''
        echo off > /sys/class/sound/ctl-led/mic/mode
        echo off > /sys/class/sound/ctl-led/speaker/mode
      '';
    };
  };
}
