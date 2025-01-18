{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vm;

  width = builtins.toString (my.gui.display.width / my.gui.display.scale);
  height = builtins.toString (my.gui.display.height / my.gui.display.scale);
  # refreshRate = builtins.toString my.gui.display.refreshRate;

  waydroidPkg = lib.getExe pkgs.waydroid;
in
{
  options.my.programs.vm = {
    enable = lib.mkEnableOption "VM";
    waydroid.enable = lib.mkEnableOption "Waydroid";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      services = {
        spice-webdavd.enable = true;
        spice-vdagentd.enable = true;
      };

      environment.systemPackages = with pkgs; [ virtiofsd ];
    })

    (lib.mkIf cfg.waydroid.enable {
      virtualisation.waydroid.enable = true;

      environment.systemPackages = with pkgs; [
        (writeShellScriptBin "waydroid-init" # sh
          ''
            ${waydroidPkg} prop set persist.waydroid.udev true
            ${waydroidPkg} prop set persist.waydroid.uevent true

            ${waydroidPkg} prop set persist.waydroid.width ""
            ${waydroidPkg} prop set persist.waydroid.height ""
            ${waydroidPkg} prop set persist.waydroid.width ${width}
            ${waydroidPkg} prop set persist.waydroid.height ${height}

            sudo systemctl restart waydroid-container.service
          ''
        )
      ];
    })
  ];
}
