{ den, ... }: {
  den.default.includes = [ den.aspects.netowrking.firewall ];

  den.aspects.netowrking.firewall = {
    nixos = {
      networking.firewall.enable = true;
    };
  };
}
