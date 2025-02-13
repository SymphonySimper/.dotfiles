{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.networking;
in
{
  imports = [
    ./begone.nix
  ];

  options.my.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf cfg.enable {
    my.user.sudo.nopasswd = [
      "/run/current-system/sw/bin/systemctl restart NetworkManager"
    ];

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
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "mynetwork" # sh
        ''
          case "$1" in
            get) nmcli -p -g type connection show --active | head -n1 | cut -d '-' -f3 ;;
            reload) sudo systemctl restart NetworkManager &&  ${
              lib.my.mkNotification { title = "Restarted network manager"; }
            } ;;
          esac
        ''
      )
    ];
  };
}
