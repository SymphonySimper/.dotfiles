{
  my,
  pkgs,
  lib,
  ...
}:
let
  name = "my-kill-chromium-gracefully";
  script =
    pkgs.writeShellScriptBin name # sh
      ''
        browsers=('chrome' 'chromium' 'brave')
        for browser in "''${browsers[@]}"; do
          if [[ -n "$(${lib.getExe' pkgs.toybox "pgrep"} $browser)" ]]; then
            ${lib.getExe pkgs.killall} "$browser" --wait
          fi
        done
      '';
in
lib.mkMerge [
  {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;

      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];
    };
  }

  (lib.mkIf my.gui.desktop.enable {
    # refer: https://wiki.gentoo.org/wiki/Chrome#Troubleshooting
    systemd.user.services."${name}" = {
      Unit = {
        Description = "Help Chrome close gracefully";
        DefaultDependencies = "no";
        Before = "shutdown.target";
      };

      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe script;
      };

      Install.WantedBy = [
        "halt.target"
        "reboot.target"
        "shutdown.target"
      ];
    };
  })
]
