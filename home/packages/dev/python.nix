{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    python3
    conda
  ];

  xdg.configFile."conda/condarc" = {
    text = ''
      auto_activate_base: false
      changeps1: false
    '';
  };
}
