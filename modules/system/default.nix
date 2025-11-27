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

    bash.enableLsColors = false;
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
      };
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
  system.stateVersion = "23.11"; # Do no change
}
