{ config, lib, pkgs, userSettings, ... }:
{
  imports = [ ./packages/default.nix ];

  # Enable flakse
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11"; # Do no change

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Required to make mamba-managed Python run without an FHS environment
  programs.nix-ld.enable = true;

  users.users.${userSettings.username} = {
    isNormalUser = true;
    home = "/home/${userSettings.username}";
    description = "${userSettings.username}";
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
