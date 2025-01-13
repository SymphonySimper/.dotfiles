{ pkgs, ... }:
{
  my = {
    home = {
      packages = with pkgs; [
        python3
      ];

      shell.aliases = {
        py = "python";
        pvc = "python -m venv .venv";
        pva = "source .venv/bin/activate";
        pfrd = "flask run --debug";
      };
    };

    programs.nvim = {
      treesitter = [ "python" ];

      lsp = {
        pyright.enable = true;
        ruff.enable = true;
      };

      formatter.ft.python = "ruff_format";
    };
  };

  programs.poetry = {
    enable = true;
    settings.virtualenvs = {
      create = true;
      in-project = true;
    };
  };
}
