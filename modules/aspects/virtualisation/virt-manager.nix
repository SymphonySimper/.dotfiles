{
  den.aspects.virtualisation.virt-manager = {
    nixos = { config, pkgs, ... }: {
      users.groups.libvirtd.members = config.users.groups.weel.memebers;

      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      services = {
        spice-webdavd.enable = true;
        spice-vdagentd.enable = true;
      };

      environment.systemPackages = with pkgs; [ virtiofsd ];
    };
  };
}
