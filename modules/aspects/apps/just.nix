{
  den.aspects.apps.just = {
    homeManager =
      { pkgs, lib, ... }:
      let
        package = pkgs.just;
      in
      {
        home.packages = [ package ];

        programs.helix.languages = {
          language = [
            {
              name = "just";
              formatter = {
                command = lib.getExe package;
                args = [ "--dump" ];
              };
            }
          ];
        };
      };
  };
}
