{ ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;

    autoPrune = {
      enable = true;
    };

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
