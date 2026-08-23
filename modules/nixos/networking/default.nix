{ ... }: {
  imports = [
    ./dns/cloudflare.nix
    ./firewall.nix
  ];
}
