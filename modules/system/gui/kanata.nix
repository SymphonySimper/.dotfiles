{ lib, my, ... }:
{
  config = lib.mkIf my.gui.desktop.enable {
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
