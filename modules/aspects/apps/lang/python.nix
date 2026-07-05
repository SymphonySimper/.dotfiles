{
  den.aspects.apps.lang.python = {
    homeManager = { pkgs, lib, ... }: {
      home.packages = [ pkgs.python3 ];

      programs.uv = {
        enable = true;
        settings = {
          python-downloads = "automatic";
        };
      };

      programs.helix = {
        ignores = [
          ".venv"
          "venv"
          "**/__pycache__/"
        ];

        languages = rec {
          language-server = {
            ruff = {
              command = lib.getExe pkgs.ruff;
              args = [ "server" ];
            };

            ty = {
              command = lib.getExe pkgs.ty;
              args = [ "server" ];
            };
          };

          language = [
            {
              name = "python";
              language-servers = [
                "ruff"
                "ty"
              ];
              formatter = {
                command = language-server.ruff.command;
                args = [
                  "format"
                  "--line-length"
                  "88"
                  "-"
                ];
              };
            }
          ];
        };
      };
    };
  };
}
