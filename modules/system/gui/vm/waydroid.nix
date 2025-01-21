{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vm;

  res = {
    desktop = {
      width = builtins.toString (my.gui.display.width / my.gui.display.scale);
      height = builtins.toString (my.gui.display.height / my.gui.display.scale);
    };

    steam = {
      width = builtins.toString config.my.programs.steam.display.width;
      height = builtins.toString config.my.programs.steam.display.height;
    };
  };

  waydroidPkg = lib.getExe pkgs.waydroid;

  mkWaydroidSetRes =
    for:
    # sh
    ''
      ${waydroidPkg} prop set persist.waydroid.width ""
      ${waydroidPkg} prop set persist.waydroid.height ""
      ${waydroidPkg} prop set persist.waydroid.width ${res.${for}.width}
      ${waydroidPkg} prop set persist.waydroid.height ${res.${for}.height}
    '';

  westonConfig = pkgs.writeText "weston-steam.ini" (
    lib.generators.toINI { } {
      libinput.enable-tap = true;
      shell.panel-position = "none";
      output = {
        name = my.gui.display.name;
        mode = "${res.steam.width}x${res.steam.height}";
      };
    }
  );
in
{
  options.my.programs.vm.waydroid.enable = lib.mkEnableOption "Waydroid";

  config = lib.mkIf cfg.waydroid.enable {
    virtualisation.waydroid.enable = true;

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "waydroid-init" # sh
        ''
          ${waydroidPkg} prop set persist.waydroid.udev true
          ${waydroidPkg} prop set persist.waydroid.uevent true

          ${mkWaydroidSetRes "desktop"}

          sudo systemctl restart waydroid-container.service
        ''
      )
      (writeShellScriptBin "waydroid-steam" # sh
        ''
          ${mkWaydroidSetRes "steam"}
          ${waydroidPkg} show-full-ui
        ''
      )
      (writeShellScriptBin "weston-waydroid" # sh
        ''
          export LD_PRELOAD=""
          # ${lib.getExe pkgs.weston} -c ${westonConfig} --shell=kiosk --width=${res.steam.width} --height=${res.steam.height} -- waydroid-steam
          ${lib.getExe pkgs.weston} -c ${westonConfig} --shell=kiosk -- waydroid-steam
        ''
      )
      (makeDesktopItem rec {
        name = "Weston Waydroid";
        desktopName = name;
        exec = "weston-waydroid";
      })
    ];
  };
}
