{ pkgs, ... }:
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
