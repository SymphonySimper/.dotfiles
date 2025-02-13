{ lib, my, ... }:
{
  config = lib.mkIf my.gui.desktop.enable {
    my.user.sudo.nopasswd = [
      "/run/current-system/sw/bin/systemctl restart kanata-keyboard.service"
    ];

    services.kanata = {
      enable = true;
      keyboards.keyboard = {
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
}
