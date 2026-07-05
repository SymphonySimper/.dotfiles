{ den, ... }: {
  den.default.includes = [ den.aspects.xdg ];

  den.aspects.xdg = {
    homeManager = {
      xdg = {
        enable = true;

        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;
        };
      };
    };
  };
}
