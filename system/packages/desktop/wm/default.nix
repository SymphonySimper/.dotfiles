{ ... }:
{
  imports = [
    # ./hyprland.nix
    ./sway.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.dconf.enable = true;
}
