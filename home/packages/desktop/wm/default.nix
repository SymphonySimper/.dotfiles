{ ... }:
{
  imports = [
    ./common/default.nix
    ./sway.nix
  ];

  services.udiskie.enable = true;
}
