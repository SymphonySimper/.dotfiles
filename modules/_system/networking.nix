{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.networking;
in
{
  options.my.networking = {
    enable = lib.mkEnableOption "networking" // {
      default = true;
    };

    nm.enable = lib.mkEnableOption "NetworkManager";
    firewall.enable = lib.mkEnableOption "firewall";
    enableCloudflareDNS = lib.mkEnableOption "Cloudflare DNS";
  };

  config = lib.mkIf cfg.enable {
    my = {
      user = {
        groups = [ "networkmanager" ];
        sudo.nopasswd = lib.lists.optional (cfg.nm.enable) "${my.dir.runBin}/systemctl restart NetworkManager";
      };

      networking = {
        nm.enable = lib.mkDefault true;
        firewall.enable = lib.mkDefault true;
      };
    };

    networking = {
      nameservers = lib.lists.optionals cfg.enableCloudflareDNS [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];

      networkmanager = {
        enable = cfg.nm.enable;
        dns = lib.mkIf cfg.enableCloudflareDNS "none";
      };

      firewall = {
        enable = cfg.firewall.enable;
        allowedTCPPorts = [
          5173 # vite
        ];
      };
    };
  };
}
