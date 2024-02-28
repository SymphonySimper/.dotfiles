{ config, pkgs, userSettings, ... }:
{
  imports = [
    ./packages/default.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

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
