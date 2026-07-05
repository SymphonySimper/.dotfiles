{
  den.aspects.apps.android.tools = {
    nixos = { config, pkgs, ... }: {
      users.groups.adbusers.members = config.users.groups.wheel.members;
      services.gvfs.enable = true;
      environment.systemPackages = [ pkgs.android-tools ];
    };
  };
}
