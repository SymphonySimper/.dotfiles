{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [ ];
    };

    # Enable swaylock
    security.pam.services.swaylock = { };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      loginShellInit = lib.my.mkTTYLaunch {
        command = "sway";
        dbus = false;
      };
    };
    security.polkit.enable = true;

    # Default username for all tty
    # services.getty = {
    #   loginOptions = "-p -- ${userSettings.name.user}";
    #   extraArgs = [
    #     "--noclear"
    #     "--skip-login"
    #   ];
    # };

    # Skip username only for tty1 and tty3
    systemd.services = {
      "getty@tty1" = {
        overrideStrategy = "asDropin";
        serviceConfig.ExecStart = [
          ""
          "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${config.my.user.name}' --noclear --skip-login %I $TERM"
        ];
      };
    };
  };
}
