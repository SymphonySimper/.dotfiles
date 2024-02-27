{ config, pkgs, ... }:
let 
username = "symph";
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Do not change
  home.stateVersion = "23.11"; 

  home.packages = with pkgs; [
    neofetch
    zsh
    neovim
    helix
    rustup
    nodejs
    nodePackages_latest.npm
    nodePackages_latest.pnpm
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
