let
  mkSystemdTimer =
    {
      name,
      desc,
      time,
      ExecStart,
    }:
    {
      systemd.user.services.${name} = {
        Unit = {
          Description = desc;
          After = "graphical-session.target";
        };
        Service = {
          Type = "oneshot";
          ExecStart = ExecStart;
        };
      };

      systemd.user.timers."${name}" = {
        Unit = {
          Description = "Run ${name} every ${time}";
          After = "graphical-session.target";
        };
        Timer = {
          OnBootSec = "${time}";
          OnUnitActiveSec = "${time}";
          Unit = "${name}.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
in
mkSystemdTimer
