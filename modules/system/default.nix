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
        "${my.dir.dev}" = defaultDirConfig;
        "${my.dir.dev}/work" = defaultDirConfig;
        "${my.dir.data}" = defaultDirConfig;
      };
    };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
  };

  time.timeZone = lib.mkDefault "Asia/Kolkata";
  services.timesyncd.enable = true;

  i18n =
    let
      locale = "en_US.UTF-8";
    in
    {
      defaultLocale = locale;

      extraLocaleSettings = {
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
    };

  nixpkgs.hostPlatform = lib.mkDefault my.system;
  system.stateVersion = "23.11"; # Do no change
}
