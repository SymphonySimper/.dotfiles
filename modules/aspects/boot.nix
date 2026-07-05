{
  den.aspects.boot = {
    nixos = {
      boot.kernelParams = [ "quiet" ];
      boot.consoleLogLevel = 0;

      boot.loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "5";
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
