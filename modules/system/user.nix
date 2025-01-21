{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.user.groups = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Adds groups to extraGroups";
    default = [ ];
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
            "wheel"
            "networkmanager"
            "uinput"
            "libvirtd"
            "video"
            "input"
            "disk"
          ]
          ++ config.my.user.groups
        );
      };
    };
  };
}
