{ lib, config, ... }:
let
  cfg = config.my.networking;
in
{
  options.my.networking = {
    enable = lib.mkEnableOption "networking";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = "nixos"; # Define your hostname.
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [
          # 80 # 443
          5173
        ];
      };
      hosts = {
        "0.0.0.0" = (import ./begone.nix);
      };
    };
  };
}
