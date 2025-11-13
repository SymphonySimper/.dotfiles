{
  my,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin

    # cli
    ./boot.nix
    ./networking.nix
    ./tty.nix
    ./user.nix

    # gui
    ./browser.nix
    ./desktop.nix

    # cli + gui
    ./android.nix
    ./vm.nix

    # misc
    ../common
    ./hardware
  ];

  my = {
    common.system = true;
    boot.enable = lib.mkDefault false;
    networking.enable = lib.mkDefault true;

    programs = {
      android.enable = lib.mkDefault false;
      browser.enable = lib.mkDefault my.gui.enable;
      desktop.enable = lib.mkDefault my.gui.desktop.enable;
      vm.enable = lib.mkDefault false;
    };
  };

  programs = {
    git.enable = lib.mkDefault true;

    # FHS environment
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };
  };

  # Clean /tmp folder on boot
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;

  systemd.tmpfiles.settings =
    let
      defaultDirConfig.d = {
        group = "users";
        user = my.name;
        mode = "0755";
      };
    in
    {
      "${my.name}-fav-dirs" = {
        "${my.dir.data}" = defaultDirConfig;
        "${my.dir.dev}" = defaultDirConfig;
        "${my.dir.work}" = defaultDirConfig;
      };
    };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
  };

  time.timeZone = lib.mkDefault "Asia/Kolkata";
  services.timesyncd.enable = true;

  # refer: https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED
  i18n = rec {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault my.system;
  system.stateVersion = "23.11"; # Do no change
}
