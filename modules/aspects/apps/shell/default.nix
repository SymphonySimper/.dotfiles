{ den, ... }: {
  den.default.includes = [ den.aspects.apps.shell.default ];

  den.aspects.apps.shell.default = {
    nixos = {
      programs = {
        command-not-found.enable = false;
        bash.enableLsColors = false;
      };
    };

    homeManager = { config, ... }: {
      home = {
        sessionVariables = {
          LS_COLORS = ""; # Some programs misbehave when this is not set.
        };

        sessionPath = [ "${config.xdg.dataHome}/../bin" ];
      };
    };
  };
}
