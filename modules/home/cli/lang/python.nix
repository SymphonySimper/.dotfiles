{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      python3
      micromamba
    ];

    shellAliases = {
      py = "python";
      pc = "micromamba";
      pca = "micromamba activate";
      pcd = "micromamba deactivate";
      pcce = "micromamba create -n";
      pcrm = "micromamba env remove -n";
      pfrd = "flask run --debug";
    };
    sessionVariables = {
      # CONDARCA = "${config.xdg.configHome}/conda/condarc";
      MAMBA_ROOT_PREFIX = "${config.xdg.dataHome}/mamba";
    };
  };

  programs = {
    poetry = {
      enable = true;
      settings.virtualenvs = {
        create = true;
        in-project = true;
      };
    };
    zsh.initExtra = # sh
      ''
        eval "$(micromamba shell hook -s zsh)"
      '';
    bash.initExtra = # sh
      ''
        eval "$(micromamba shell hook -s bash)"
      '';
  };

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
