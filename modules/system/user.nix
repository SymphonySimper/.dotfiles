{ pkgs, my, ... }:
{
  programs.zsh.enable = true;
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
    users.${my.name} = {
      initialHashedPassword = "$6$zzXPOtlNAnpUTgHe$.VZIkoqeZQWtACW6JFOZBeUUT5ds7PDpfoMZQOfWNCND0ukdGVd7jA2Ko86g8tPDxfpM3D0rVkCRUfEz/hJiN0";
      isNormalUser = true;
      home = my.dir.home;
      description = "${my.fullName}";
      extraGroups = [
        "wheel"
        "networkmanager"
        "uinput"
        "libvirtd"
        "video"
        "input"
        "disk"
      ];
    };
  };
}
