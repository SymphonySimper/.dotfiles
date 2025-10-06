{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hardware.bluetooth;
in
{
  options.my.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth";
    gui.enable = lib.mkEnableOption "GUI";
    tui.enable = lib.mkEnableOption "TUI";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };

    services.blueman.enable = cfg.gui.enable;
    environment.systemPackages = lib.lists.optionals cfg.tui.enable [
      # pkgs.overskride # gui
      pkgs.bluetui
    ];
  };
}
