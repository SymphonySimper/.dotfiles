{ lib, ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = lib.mkForce false;
    liveRestore = false;

    autoPrune = {
      enable = true;
    };

    rootless = {
      enable = false;
      setSocketVariable = true;
    };
  };
}
