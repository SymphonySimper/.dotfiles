{ ... }: {
  imports = [
    ./dns/cloudflare.nix
    ./firewall.nix
  ];

  hardware.facter.detected.dhcp.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
}
