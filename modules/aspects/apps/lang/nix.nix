{
  den.aspects.apps.lang.nix = {
    homeManager = { pkgs, lib, ... }: {
      programs.helix.languages = {
        language-server.nixd = {
          command = lib.getExe pkgs.nixd;
          args = [ "--inlay-hints=false" ];
          config.nixd = {
            nixpkgs.expr = "import <nixpkgs> { }";
          };
        };

        language = [
          {
            name = "nix";
            formatter.command = lib.getExe pkgs.nixfmt;
            language-servers = [
              {
                name = "nixd";
                except-features = [ "format" ];
              }
            ];
          }
        ];
      };
    };
  };
}
