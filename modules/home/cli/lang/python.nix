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

  programs.poetry = {
    enable = true;
    settings.virtualenvs = {
      create = true;
      in-project = true;
    };
  };
}
