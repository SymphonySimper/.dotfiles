{ den, ... }: {
  den.aspects.apps.android.studio = {
    includes = [ (den.batteries.unfree [ "android-studio" ]) ];

    nixos = { config, pkgs, ... }: {
      users.groups.kvm.members = config.users.groups.wheel.members; # for emulators
      environment.systemPackages = [ (pkgs.android-studio.override { forceWayland = true; }) ];
    };
  };
}
