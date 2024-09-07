{ ... }:
let
  locale = "en_US.UTF-8";
in
{
  imports = [
    ./audio.nix
    ./boot.nix
    ./networking.nix
    ./powerManagement.nix
    ./systemd.nix
    ./users.nix

    ./hardware/default.nix
    ./programs/default.nix
  ];

  system.stateVersion = "23.11"; # Do not change

  nix = {
    # Enable flakse
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Storage optimise
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Required to make mamba-managed Python run without an FHS environment
  programs.nix-ld.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  services.timesyncd.enable = true;

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
}
