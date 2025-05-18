{
  inputs,
  my,
  lib,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.hmModules.nix-index

    ../common

    # cli
    ./editor.nix
    ./file-manager.nix
    ./mux.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
    ./top.nix
    ./utility.nix
    ./vcs.nix

    ./scripts

    # gui
    ./browser.nix
    ./music.nix
    ./office.nix
    ./terminal.nix
    ./theme.nix
    ./video.nix

    ./desktop
  ];

  my = {
    common.system = false;

    programs = {
      # cli
      scripts.enable = lib.mkDefault true;

      # gui
      browser.enable = lib.mkDefault my.gui.enable;
      desktop.enable = lib.mkDefault my.gui.desktop.enable;
      music.enable = lib.mkDefault my.gui.enable;
      office.enable = lib.mkDefault my.gui.enable;
      video.enable = lib.mkDefault my.gui.enable;
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
