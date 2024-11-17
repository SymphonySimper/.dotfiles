{
  pkgs,
  lib,
  my,
  ...
}:
let
  skipUsername = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${my.name}' --noclear --skip-login %I $TERM"
    ];
  };
in
{
  imports = [ ./sway.nix ];

  # Enable swaylock
  security.pam.services.swaylock = { };
  services.udisks2.enable = true;

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
  #   loginOptions = "-p -- ${my.name}";
  #   extraArgs = [
  #     "--noclear"
  #     "--skip-login"
  #   ];
  # };

  # Skip username for tty1 and tty3
  systemd.services = {
    "getty@tty1" = skipUsername;
    "getty@tty3" = skipUsername;
  };
}
