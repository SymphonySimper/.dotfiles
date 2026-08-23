{ ... }: {
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      5173 # vite
    ];
  };
}
