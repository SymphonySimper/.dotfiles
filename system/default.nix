{ config, lib, pkgs, userSettings, ... }:
let
  locale = "en_US.UTF-8";
in
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
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    # packages = with pkgs; [
    #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # ];
  };
}
