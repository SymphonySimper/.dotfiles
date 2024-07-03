{ pkgs, ... }: {
  programs.java.enable = true;
  programs.steam = {
    enable = true;
    package = pkgs.steam.override { withJava = true; };
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };
}
