{
  den.aspects.apps.just = {
    homeManager =
      { pkgs, lib, ... }:
      let
        package = pkgs.just;
      in
      {
        home.packages = [ package ];

        programs.helix.lang.just = {
          formatter = {
            command = lib.getExe package;
            args = [ "--dump" ];
          };
        };
      };
  };
}
