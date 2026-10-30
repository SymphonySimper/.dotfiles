{
  config,
  pkgs,
  lib,
  ...
}:
let
  package = pkgs.handy;
  handy = lib.getExe pkgs.handy;
in
{
  options.services.handy = {
    enable = lib.mkEnableOption "Handy (Speech-to-text)";
  };

  config = lib.mkIf config.services.handy.enable {
    home.packages = [
      package
      pkgs.dotool # typing tool
    ];

    programs.clipboard.enable = true;

    desktop.keybinds = [
      {
        key = "F9";
        command = "${handy} --toggle-transcription";
      }
      {
        mods = [
          "ctrl"
          "alt"
        ];
        key = "Escape";
        command = "${handy} --cancel";
      }
    ];

    # yoinked from: https://github.com/cjpais/Handy/blob/main/nix/hm-module.nix
    systemd.user.services.handy = {
      Unit = {
        Description = "Handy speech-to-text";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = handy;
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
