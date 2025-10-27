{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.user;
  groupSudo = "wheel";
in
{
  options.my.user = {
    sudo = {
      nopasswd = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Sudo commands to run without password";
        default = [ ];
      };
    }
    // (lib.my.mkCommandOption {
      category = "Sudo";
      command = "/run/wrappers/bin/sudo";
    });

    groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Adds groups to extraGroups";
      default = [ ];
    };

    bin = lib.mkOption {
      type = lib.types.str;
      description = "Current bin Path";
      default = "/run/current-system/sw/bin";
      readOnly = true;
    };
  };

  config = {
    programs = {
      bash.completion.enable = true;
      command-not-found.enable = false;
    };

    users = {
      mutableUsers = true;
      users.${my.name} = {
        initialPassword = "nix-is-cool";
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
  };
}
