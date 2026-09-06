{ config, lib, ... }: {
  imports = [
    ./plugins

    ./options.nix
  ];

  programs.neovim = {
    enable = true;
    waylandSupport = config.desktop.enable;
  };
}
