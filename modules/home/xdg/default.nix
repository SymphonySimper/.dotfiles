{ lib, ... }: {
  imports = [ ./autostart.nix ];

  xdg = {
    enable = lib.mkDefault true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };
}
