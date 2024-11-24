{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.programs.vm = {
    enable = lib.mkEnableOption "VM";
  };
  config = lib.mkIf config.my.programs.vm.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    services = {
      spice-webdavd.enable = true;
      spice-vdagentd.enable = true;
    };
    environment.systemPackages = with pkgs; [ virtiofsd ];
  };
}
