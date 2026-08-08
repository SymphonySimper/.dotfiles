{ den, lib, ... }: {
  den.aspects.options = {
    homeManager.options.desktop = {
      default = {
        browser = lib.mkOption {
          type = lib.types.str;
          description = "Default browser";
          example = "chromium";
        };

        terminal = lib.mkOption {
          type = lib.types.str;
          description = "Default terminal";
          example = "kitty";
        };
      };
    };
  };

  den.aspects.desktop.common = {
    includes = with den.aspects; [
      hardware.audio

      networking.networkmanager

      theme.fonts
      theme.gtk

      apps.chromium
      apps.kitty
      apps.clipboard

      xdg.autostart
    ];

    nixos = {
      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
      };
    };
  };
}
