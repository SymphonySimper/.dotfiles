{
  den.aspects.networking.dns.cloudflare = {
    nixos = {
      networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];

      networking.networkmanager.dns = "none";
    };
  };
}
