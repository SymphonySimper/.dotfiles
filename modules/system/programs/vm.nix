{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.system.programs.vm = {
    enable = lib.mkEnableOption "vm";
  };

  config = lib.mkIf config.my.system.programs.vm.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    services = {
      spice-webdavd.enable = true;
      spice-vdagentd.enable = true;
    };
    environment.systemPackages = with pkgs; [ virtiofsd ];
  };
}
