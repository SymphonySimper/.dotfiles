{ pkgs, lib, ... }:
{
  programs.helix = {
    grammars = [ "python" ];

    lsp = {
      pyright = {
        command = lib.getExe' pkgs.pyright "pyright-langserver";
        config.python.analysis.typeCheckingMode = "basic";
      };
      ruff = {
        command = lib.getExe' pkgs.ruff "ruff";
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
