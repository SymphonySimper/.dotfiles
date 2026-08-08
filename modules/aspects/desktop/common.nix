{ den, ... }: {
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
