{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.programs.virt-manager.enable {
    users.groups.libvirtd.members = config.users.groups.wheel.members;

    virtualisation.libvirtd.enable = true;

    services = {
      spice-webdavd.enable = true;
      spice-vdagentd.enable = true;
    };

    environment.systemPackages = with pkgs; [ virtiofsd ];
  };
}
