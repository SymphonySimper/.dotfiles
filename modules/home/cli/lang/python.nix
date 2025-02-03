{ pkgs, lib, ... }:
{
  programs.helix = {
    grammars = [ "python" ];

    lsp = {
      pyright = {
        command = "${pkgs.pyright}/bin/pyright-langserver";
        config.python.analysis.typeCheckingMode = "basic";
      };
      ruff = {
        command = "${pkgs.ruff}/bin/ruff";
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
