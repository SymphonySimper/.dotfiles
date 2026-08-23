{ lib, ... }: {
  programs.man = {
    enable = lib.mkDefault true;
    generateCaches = true;
  };
}
