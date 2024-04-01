{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python3
    micromamba
  ];

  xdg.configFile."mamba/mambarc" = {
    text = ''
      channels:
        - conda-forge
      always_yes: false
      auto_activate_base: false
      changeps1: false
    '';
  };

  # xdg.configFile."conda/condarc" = {
  #   text = ''
  #     auto_activate_base: false
  #     changeps1: false
  #   '';
  # };
}
