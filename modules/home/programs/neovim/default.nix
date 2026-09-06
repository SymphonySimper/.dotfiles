{ config, ... }: {
  imports = [
    ./plugins

    ./options.nix
  ];

  programs.neovim = {
    enable = true;
    # defaultEditor = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    waylandSupport = config.desktop.enable;
  };
}
