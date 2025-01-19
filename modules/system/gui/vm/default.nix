{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vm;
in
{
  imports = [ ./waydroid.nix ];

  options.my.programs.vm.enable = lib.mkEnableOption "VM";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    services = {
      spice-webdavd.enable = true;
      spice-vdagentd.enable = true;
    };

    environment.systemPackages = with pkgs; [ virtiofsd ];
  };
}
