{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.programs.virt-manager.enable {
    users.groups.libvirtd.members = config.users.groups.wheel.members;

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
}
