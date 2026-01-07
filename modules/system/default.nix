{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # cli
    ./boot.nix
    ./networking.nix
    ./user.nix

    # gui
    ./browser.nix
    ./desktop.nix
    ./steam.nix

    # cli + gui
    ./android.nix
    ./vm.nix

    # misc
    ../common
    ./hardware
  ];

  programs = {
    # FHS environment
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };

    bash.enableLsColors = false;
  };

  networking.hostName = my.profile;

  # Clean /tmp folder on boot
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  fonts = lib.mkIf my.gui.enable {
    enableDefaultPackages = true;
    fontDir.enable = true;
  };

  time.timeZone = lib.mkDefault "Asia/Kolkata";
  services.timesyncd.enable = true;

  # refer: https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.hostPlatform = lib.mkDefault my.system;
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  system.stateVersion = "23.11"; # Do no change
}
