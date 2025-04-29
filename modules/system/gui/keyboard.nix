{ lib, my, ... }:
{
  config = lib.mkIf my.gui.desktop.enable {
    services.keyd = {
      enable = true;

      keyboards.default = {
        ids = [ "*" ];
        settings.main.capslock = "overload(control, esc)";
      };
    };
  };
}
