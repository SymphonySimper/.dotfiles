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
    enable = lib.mkEnableOption "networking";
    nm.enable = lib.mkEnableOption "NetworkManager";
    firewall.enable = lib.mkEnableOption "firewall";

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Hostname";
      default = my.profile;
    };
  };

  config = lib.mkMerge [
    {
      networking = {
        hostName = cfg.hostName;
      };
    }

    (lib.mkIf cfg.enable {
      my = {
        user.sudo.nopasswd = lib.lists.optional (cfg.nm.enable) "${my.dir.runBin}/systemctl restart NetworkManager";

        networking = {
          nm.enable = lib.mkDefault true;
          firewall.enable = lib.mkDefault true;
        };
      };

      networking = {
        networkmanager = {
          enable = cfg.nm.enable;
        };

        firewall = {
          enable = cfg.firewall.enable;
          allowedTCPPorts = [
            5173 # vite
          ];
        };
      };
    })
  ];
}
