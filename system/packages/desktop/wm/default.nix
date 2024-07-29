{ userSettings, pkgs, ... }:
{
  imports = [
    # ./hyprland.nix
    ./sway.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.dconf.enable = true;

  # Default username for all tty
  # services.getty = {
  #   loginOptions = "-p -- ${userSettings.username}";
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
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${userSettings.username}' --noclear --skip-login %I $TERM"
    ];
  };
}
