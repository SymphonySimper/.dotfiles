{ pkgs, lib, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "python" ];

    lsp.servers = {
      pyright.enable = true;
      ruff.enable = true;
    };

    formatter.ft.python = "ruff_format";
  };

  programs.helix = {
    grammars = [ "python" ];

    lsp = {
      pyright = {
        command = "${lib.getExe pkgs.pyright}";
        config.python.analysis.typeCheckingMode = "basic";
      };
      ruff = {
        command = "${lib.getExe pkgs.ruff}";
        args = [ "server" ];
      };
    };

    language = [
      {
        name = "python";
        language-servers = [
          "pyright"
          "ruff"
        ];
        formatter = {
          command = "${lib.getExe pkgs.ruff}";
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
}
