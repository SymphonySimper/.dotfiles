{ ... }:
{
  imports = [
    ./common/default.nix
    ./hyprland.nix
    ./sway.nix
  ];

  services.udiskie.enable = true;
}
