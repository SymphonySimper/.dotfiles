{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      python3
    ];

    shellAliases = {
      py = "python";
      pvc = "python -m venv .venv";
      pva = "source .venv/bin/activate";
      pfrd = "flask run --debug";
    };
  };

  programs = {
    nixvim.plugins = {
      treesitter.grammars = [ "python" ];

      lsp.servers = {
        pyright.enable = true;
        ruff.enable = true;
      };

      formatter.ft.python = "ruff_format";
    };

    poetry = {
      enable = true;
      settings.virtualenvs = {
        create = true;
        in-project = true;
      };
    };
  };
}
