{ ... }: {
  my = {
    wsl = {
      enable = true;
      defaultUser = "symph";
    };

    programs.vm.docker = {
      enable = false;
      enableRootless = true;
    };
  };
}
