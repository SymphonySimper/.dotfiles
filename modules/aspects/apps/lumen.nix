{
  den.aspects.apps.lumen = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.lumen ];
    };
  };
}
