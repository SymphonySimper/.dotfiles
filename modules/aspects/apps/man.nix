{ den, ... }: {
  den.default.includes = [ den.aspects.apps.man ];

  den.aspects.apps.man = {
    homeManager = {
      programs.man = {
        enable = true;
        generateCaches = true;
      };
    };
  };
}
