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
  options.my.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf cfg.enable {
    my.user.sudo.nopasswd = [ "${config.my.user.bin}/systemctl restart NetworkManager" ];

    networking = {
      hostName = lib.mkDefault my.profile;
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;

      firewall = {
        enable = true;
        allowedTCPPorts = [
          5173 # vite
        ];
      };
    };
  };
}
