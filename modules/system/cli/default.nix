{ lib, ... }:
{
  imports = [
    ./docker.nix
    ./android.nix
  ];

  programs.git.enable = true;

  my.programs = {
    android.enable = lib.mkDefault false;
    docker.enable = lib.mkDefault false;
  };
}
