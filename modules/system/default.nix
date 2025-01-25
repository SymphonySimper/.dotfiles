{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  defaultDirConfig = {
    d = {
      group = "users";
      user = "${my.name}";
      mode = "0755";
    };
  };
in
{
  imports = [
    ./boot.nix
    ./font.nix
    ./locale.nix
    ./time.nix
    ./tty.nix
    ./user.nix

    ../common
    ./cli
    ./gui
    ./hardware
    ./networking
  ];

  system.stateVersion = "23.11"; # Do no change

  my = {
    common.system = true;
    boot.enable = lib.mkDefault my.gui.desktop.enable;

    networking = {
      enable = lib.mkDefault true;
      begone.enable = lib.mkDefault false;
    };

    hardware = {
      ideapad.enable = lib.mkDefault false;
      led.enable = lib.mkDefault false;
      logitech.enable = lib.mkDefault false;
      ssd.enable = lib.mkDefault false;
      bluetooth.enable = lib.mkDefault false;
      audio.enable = lib.mkDefault my.gui.desktop.enable;
      powerManagement.enable = lib.mkDefault my.gui.desktop.enable;
      cpu.amd.enable = lib.mkDefault false;
      gpu = {
        amd.enable = lib.mkDefault false;
        nvidia.enable = lib.mkDefault false;
      };
    };

    programs = {
      android.enable = lib.mkDefault false;
      docker.enable = lib.mkDefault false;
      gaming.enable = lib.mkDefault false;
      vm = {
        enable = lib.mkDefault false;
        waydroid.enable = lib.mkDefault config.my.programs.gaming.enable;
      };
    };
  };

  # FHS environment
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
    ];
  };

  # Clean /tmp folder on boot
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;

  systemd.tmpfiles.settings = {
    "${my.name}-fav-dirs" = {
      "${my.dir.dev}" = defaultDirConfig;
      "${my.dir.dev}/work" = defaultDirConfig;
      "${my.dir.data}" = defaultDirConfig;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault my.system;
}
