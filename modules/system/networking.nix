{ ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # 80 # 443
        5173
      ];
    };
  };
}
