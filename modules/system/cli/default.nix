{ ... }:
{
  imports = [
    ./docker.nix
    ./android.nix
  ];

  programs.git.enable = true;
}
