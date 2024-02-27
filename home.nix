{ config, pkgs, ... }:
let
  username = "symph";
in
{
  imports = [
    ./programs/default.nix
  ];
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
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
