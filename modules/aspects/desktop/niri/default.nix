{ den, ... }: {
  den.aspects.desktop.niri = {
    includes = with den.aspects; [ desktop.common ];

    nixos = {
      programs.niri.enable = true;
    };

    homeManager = {
      wayland.windowManager.niri = {
        enable = true;
        xwaylandSatellitePackage = null; # disable xwayland
      };

      programs.fuzzel.enable = true;
    };
  };
}
