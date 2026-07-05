{ den, ... }: {
  den.default.includes = [ den.aspects.security.sudo ];

  den.aspects.security.sudo = {
    nixos = {
      security.sudo = {
        enable = true;
        wheelNeedsPassword = true;
        execWheelOnly = true;
      };
    };
  };
}
