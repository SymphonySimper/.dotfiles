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
  imports = [
    ./begone.nix
  ];

  options.my.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf cfg.enable {
    my.user.sudo.nopasswd = [
      "/run/current-system/sw/bin/systemctl restart NetworkManager"
    ];

    networking = {
      hostName = lib.mkDefault my.profile;
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
  };
}
