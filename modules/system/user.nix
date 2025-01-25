{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.user;
  groupSudo = "wheel";

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
              [ ]
              ++ (lib.optionals (option.value.launch.command != null) [
                {
                  type = "launch";
                  name = "command";
                  value = # sh
                    ''[[ "$(tty)" = "/dev/tty${tty}" ]] && exec ${
                      if (builtins.getAttr "dbus" option.value.launch) then "${pkgs.dbus}/bin/dbus-run-session" else ""
                    } ${option.value.launch.command}'';
                }
              ])

              ++ (lib.optionals (lib.my.mkGetDefault option.value "skipUsername" false) [
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
            )
            (
              lib.attrsets.mapAttrsToList (name: value: {
                inherit name value;
              }) cfg.tty
            )
        )
      );
in
{
  options.my.user = {
    sudo.nopasswd = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Sudo commands to run without password";
      default = [ ];
    };

    tty = lib.mkOption {
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

    groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Adds groups to extraGroups";
      default = [ ];
    };
  };

  config = {
    programs.zsh.enable = true;

    users = {
      mutableUsers = true;
      defaultUserShell = pkgs.zsh;
      users.${my.name} = {
        initialHashedPassword = "$6$zzXPOtlNAnpUTgHe$.VZIkoqeZQWtACW6JFOZBeUUT5ds7PDpfoMZQOfWNCND0ukdGVd7jA2Ko86g8tPDxfpM3D0rVkCRUfEz/hJiN0";
        isNormalUser = true;
        home = my.dir.home;
        description = "${my.fullName}";
        extraGroups = lib.lists.unique (
          [
            groupSudo
            "networkmanager"
            "uinput"
            "libvirtd"
            "video"
            "input"
            "disk"
          ]
          ++ cfg.groups
        );
      };
    };

    security.sudo = {
      enable = true;
      wheelNeedsPassword = true;

      extraRules = [
        {
          groups = [ groupSudo ];
          commands = builtins.map (command: {
            inherit command;
            options = [ "NOPASSWD" ];
          }) cfg.sudo.nopasswd;
        }
      ];
    };

    systemd.services = lib.my.mkGetDefault tty "service" { };
    environment.loginShellInit = lib.strings.concatLines (
      builtins.attrValues (lib.my.mkGetDefault tty "launch" { })
    );
  };
}
