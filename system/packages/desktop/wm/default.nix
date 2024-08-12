{ userSettings, pkgs, ... }:
{
  imports = if userSettings.desktop.name == "hyprland" then [ ./hyprland.nix ] else [ ./sway.nix ];

  # Enable swaylock
  security.pam.services.swaylock = { };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  # Default username for all tty
  # services.getty = {
  #   loginOptions = "-p -- ${userSettings.name.user}";
  #   extraArgs = [
  #     "--noclear"
  #     "--skip-login"
  #   ];
  # };

  # Skip username only for tty1
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${userSettings.name.user}' --noclear --skip-login %I $TERM"
    ];
  };
}
