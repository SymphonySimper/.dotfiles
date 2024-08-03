{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.solaar ];

  hardware.logitech.wireless.enable = true;
}
