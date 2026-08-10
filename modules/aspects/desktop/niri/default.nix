{ den, ... }: {
  den.aspects.desktop.niri = {
    includes = with den.aspects; [ desktop.common ];

    nixos = {
      programs.niri.enable = true;
    };

    homeManager =
      let
        pointerAccel = {
          accel-speed = 0;
          accel-profile = "flat";
        };
      in
      {
        programs.fuzzel.enable = true;

        wayland.windowManager.niri = {
          enable = true;
          xwaylandSatellitePackage = null; # disable xwayland

          settings = {
            input = {
              keyboard.xkb = {
                options = "ctrl:nocaps";
              };

              mouse = pointerAccel;

              touchpad = {
                tap = { };
              }
              // pointerAccel;
            };
          };

          animations.off = { };
        };
      };
  };
}
