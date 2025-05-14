{ my, lib, ... }:
{
  config = lib.mkIf my.gui.desktop.enable {
    services.keyd = {
      enable = true;

      keyboards.default = {
        ids = [ "*" ];
        settings.main.capslock = "overload(control, esc)";
      };
    };

    # refer: https://github.com/rvaiya/keyd?tab=readme-ov-file#why-is-my-trackpad-is-interfering-with-input-after-enabling-keyd
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Serial Keyboards]

      MatchUdevType=keyboard
      MatchName=keyd*keyboard
      AttrKeyboardIntegration=internal
    '';
  };
}
