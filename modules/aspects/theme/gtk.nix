{
  den.aspects.theme.gtk = {
    homeManager = { config, ... }: {
      dconf = {
        enable = true;

        settings."org/gnome/desktop/interface" = {
          color-scheme = if config.theme.light then "default" else "prefer-dark";
        };
      };
    };
  };
}
