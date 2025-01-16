{ pkgs, my, ... }:
let
  mkSkipUsername =
    {
      tty ? throw "Requires tty number (ex: 1)",
    }:
    {

      # Default username for all tty
      # services.getty = {
      #   loginOptions = "-p -- ${my.name}";
      #   extraArgs = [
      #     "--noclear"
      #     "--skip-login"
      #   ];
      # };

      systemd.services."getty@tty${builtins.toString tty}" = {
        overrideStrategy = "asDropin";
        serviceConfig.ExecStart = [
          ""
          "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${my.name}' --noclear --skip-login %I $TERM"
        ];
      };
    };
in
mkSkipUsername
