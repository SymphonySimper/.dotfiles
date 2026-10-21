{ config, lib, ... }:
let
  cfg = config.networking.dns.cloudflare;

  localhost = "127.0.0.1";
in
{
  options.networking.dns.cloudflare = {
    enable = lib.mkEnableOption "Cloudflare DNS over HTTPS";
  };

  config = lib.mkIf cfg.enable {
    # Keep system DNS pointed at the local proxy instead of DHCP-provided resolvers.
    # https://wiki.nixos.org/wiki/Encrypted_DNS#Setting_nameservers
    networking.nameservers = [ localhost ];
    networking.networkmanager.dns = "none";

    # Forward local DNS requests to Cloudflare over HTTPS.
    # https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/dns-over-https-client/
    services.dnscrypt-proxy = {
      enable = true;

      settings = {
        # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
        listen_addresses = [ "${localhost}:53" ];
        server_names = [ "cloudflare" ];
        dnscrypt_servers = false;
        doh_servers = true;
      };
    };
  };
}
