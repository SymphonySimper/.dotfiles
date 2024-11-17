{
  inputs,
  lib,
  my,
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
    ./cli
    ./font.nix
    ./gui
    ./hardware
    ./locale.nix
    ./networking.nix
    ./time.nix
    ./user.nix
    (import ../common/nix.nix {
      inherit inputs;
      system = true;
    })
  ];

  system.stateVersion = "23.11"; # Do no change

  my = {
    boot.enable = lib.mkDefault my.gui.desktop.enable;
    networking.enable = lib.mkDefault true;
    hardware = {
      ideapad.enable = lib.mkDefault false;
      led.enable = lib.mkDefault false;
      logitech.enable = lib.mkDefault false;
      ssd.enable = lib.mkDefault false;
      audio.enable = lib.mkDefault my.gui.desktop.enable;
      powerManagement.enable = lib.mkDefault my.gui.desktop.enable;
      cpu.amd.enable = lib.mkDefault false;
      gpu = {
        amd.enable = lib.mkDefault false;
        nvidia.enable = lib.mkDefault false;
      };
    };
    system = {
      docker.enable = lib.mkDefault false;
      vm.enable = lib.mkDefault false;
      steam.enable = lib.mkDefault false;
      chromium.enable = lib.mkDefault my.gui.enable;
      kanata.enable = lib.mkDefault my.gui.desktop.enable;
      wm.enable = lib.mkDefault (my.gui.desktop.enable && my.gui.desktop.wm);
      de.enable = lib.mkDefault (my.gui.desktop.enable && !my.gui.desktop.wm);
    };
  };

  # FHS environment
  programs.nix-ld.enable = true;

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
