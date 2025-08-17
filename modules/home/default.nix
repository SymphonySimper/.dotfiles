{
  inputs,
  my,
  lib,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index

    ../common

    # cli
    ./dev.nix
    ./editor.nix
    ./file-manager.nix
    ./mux.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
    ./top.nix
    ./utility.nix
    ./vcs.nix
    ./work.nix

    ./scripts

    # gui
    ./browser.nix
    ./media.nix
    ./office.nix
    ./terminal.nix
    ./theme.nix

    ./desktop
  ];

  my = {
    common.system = false;

    programs = {
      # cli
      scripts.enable = lib.mkDefault true;
      mux.enable = lib.mkDefault true;

      # gui
      browser.enable = lib.mkDefault my.gui.enable;
      desktop.enable = lib.mkDefault my.gui.desktop.enable;
      media.enable = lib.mkDefault my.gui.enable;
      office.enable = lib.mkDefault my.gui.enable;
    };
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };

    configFile."nixpkgs/config.nix".text = # nix
      ''
        { allowUnfree = true; }
      '';
  };

  home = {
    username = my.name;
    homeDirectory = my.dir.home;

    stateVersion = "23.11"; # Do not change
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
