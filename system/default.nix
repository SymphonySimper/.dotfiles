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

  users = {
    mutableUsers = false;
    users.${userSettings.username} = {
      initialHashedPassword = "$y$j9T$f1QyC98UAbDK25Kge9b.l1$rXdO5ewhU1VvOwDyvf2ZZhGX8cEb/c3JWIa7jRKhka6";
      isNormalUser = true;
      home = userSettings.home;
      description = "${userSettings.description}";
      extraGroups = [ "wheel" "networkmanager" "uinput" ];
    };
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
  };

  # Clean /tmp folder on boot
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;

  systemd.tmpfiles.settings = {
    "${userSettings.username}-fav-dirs" = {
      "${userSettings.home}/lifeisfun" = {
        d = {
          group = "users";
          user = "${userSettings.username}";
          mode = "0755";
        };
      };
      "${userSettings.home}/lifeisfun/work" = {
        d = {
          group = "users";
          user = "${userSettings.username}";
          mode = "0755";
        };
      };
    };
  };

  # Storage optimise
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
