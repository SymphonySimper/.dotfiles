{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  tty =
    builtins.mapAttrs
      (
        _: values: builtins.listToAttrs (builtins.map (value: builtins.removeAttrs value [ "type" ]) values)
      )
      (
        builtins.groupBy (option: option.type) (
          builtins.concatMap
            (
              option:
              let
                tty = option.name;
              in
              lib.lists.flatten [
                (lib.optionals (option.value.launch.command != null) [
                  {
                    type = "launch";
                    name = "command-${option.name}";
                    value = # sh
                      ''[[ "$(tty)" = "/dev/tty${tty}" ]] && exec ${
                        if (builtins.getAttr "dbus" option.value.launch) then "${pkgs.dbus}/bin/dbus-run-session" else ""
                      } ${option.value.launch.command}'';
                  }
                ])

                (lib.optionals (lib.my.mkGetDefault option.value "skipUsername" false) [
                  {
                    type = "service";
                    name = "getty@tty${tty}";
                    value = {
                      overrideStrategy = "asDropin";
                      serviceConfig.ExecStart = [
                        ""
                        "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${my.name}' --noclear --skip-login %I $TERM"
                      ];
                    };

                    # Default username for all tty
                    # services.getty = {
                    #   loginOptions = "-p -- ${my.name}";
                    #   extraArgs = [
                    #     "--noclear"
                    #     "--skip-login"
                    #   ];
                    # };

                  }
                ])
              ]
            )
            (
              lib.attrsets.mapAttrsToList (name: value: {
                inherit name value;
              }) config.my.programs.tty
            )
        )
      );
in
{
  options.my.programs.tty = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          skipUsername = lib.mkEnableOption "Skip username during login";
          launch = lib.mkOption {
            type = lib.types.submodule {
              options = {
                command = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  description = "Command to run after login";
                  default = null;
                };
                dbus = lib.mkEnableOption "Run command with DBUS";
              };
            };
            description = "Command to run after login";
            default = { };
          };
        };
      }
    );
    description = "Set tty options";
    default = { };
  };

  config = {
    systemd.services = lib.my.mkGetDefault tty "service" { };
    environment.loginShellInit = lib.strings.concatLines (
      builtins.attrValues (lib.my.mkGetDefault tty "launch" { })
    );
  };
}
