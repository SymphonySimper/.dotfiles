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
        Unit.Description = desc;
        Service = {
          Type = "oneshot";
          ExecStart = ExecStart;
        };
      };

      systemd.user.timers."${name}" = {
        Unit = {
          Description = "Run ${name} every ${time}";
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
