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
in
{
  options.my.user = {
    sudo.nopasswd = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Sudo commands to run without password";
      default = [ ];
    };

    tty.skipUsername = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "Skip username for a tty (ex: 1)";
      default = [ ];
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

    systemd.services = builtins.listToAttrs (
      builtins.map (tty: {
        # Default username for all tty
        # services.getty = {
        #   loginOptions = "-p -- ${my.name}";
        #   extraArgs = [
        #     "--noclear"
        #     "--skip-login"
        #   ];
        # };

        name = "getty@tty${builtins.toString tty}";
        value = {
          overrideStrategy = "asDropin";
          serviceConfig.ExecStart = [
            ""
            "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${my.name}' --noclear --skip-login %I $TERM"
          ];
        };

      }) cfg.tty.skipUsername
    );
  };
}
