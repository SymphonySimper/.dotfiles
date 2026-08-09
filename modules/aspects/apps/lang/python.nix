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

      programs.helix = rec {
        ignores = [
          ".venv"
          "venv"
          "**/__pycache__/"
        ];

        lsp = {
          ruff = {
            command = lib.getExe pkgs.ruff;
            args = [ "server" ];
          };

          ty = {
            command = lib.getExe pkgs.ty;
            args = [ "server" ];
          };
        };

        lang.python = {
          language-servers = [
            "ruff"
            "ty"
          ];
          formatter = {
            command = lsp.ruff.command;
            args = [
              "format"
              "--line-length"
              "88"
              "-"
            ];
          };
        };
      };
    };
  };
}
