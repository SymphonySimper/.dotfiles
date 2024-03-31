{ config, lib, pkgs, userSettings, ... }:
{
  # Enable flakse
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11"; # Do no change

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.${userSettings.username} = {
    isNormalUser = true;
    home = "/home/${userSettings.username}";
    description = "${userSettings.username}";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
}
