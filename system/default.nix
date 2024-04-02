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

  networking.hostName = "nixos"; # Define your hostname.

  users.users.${userSettings.username} = {
    isNormalUser = true;
    home = "/home/${userSettings.username}";
    description = "${userSettings.username}";
    extraGroups = [ "wheel" "networkmanager" ];
  };


  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # fonts.fontconfig.enable = true;
  # fonts.packages = with pkgs; [
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];
}
