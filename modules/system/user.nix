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

    groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Adds groups to extraGroups";
      default = [ ];
    };
  };

  config = {
    programs.bash.completion.enable = true;

    users = {
      mutableUsers = true;
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
  };
}
