{ ... }:
{
  imports = [
    ./common
    ./sway.nix
  ];

  services.udiskie.enable = true;
}
