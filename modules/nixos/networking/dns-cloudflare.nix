{ config, lib, ... }:
let
  cfg = config.networking.dns.cloudflare;
in
{
  options.networking.dns.cloudflare = {
    enable = lib.mkEnableOption "Cloudflare";
  };

  config = lib.mkIf cfg.enable {
    networking.nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    networking.networkmanager.dns = "none";
  };
}
