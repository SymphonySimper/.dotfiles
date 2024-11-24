{ lib, config, ... }:
{
  options.my.programs.kanata = {
    enable = lib.mkEnableOption "Kanata";
  };
  config = lib.mkIf config.my.programs.kanata.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        keyboard = {
          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            "/dev/input/by-path/pci-0000:04:00.3-usb-0:1:1.0-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = # kbd
            ''
              (defsrc 
                caps
              )

              (defalias
                escctrl (tap-hold 100 100 esc lctl)
              )

              (deflayer base
                @escctrl
              )
            '';
        };
      };
    };
  };
}
