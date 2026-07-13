{
  den.aspects.apps.clipboard = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.wl-clipboard ];
    };
  };
}
