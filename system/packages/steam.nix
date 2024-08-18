{ ... }:
{
  # Refer: https://nixos.wiki/wiki/Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  programs.gamescope = {
    # set launch options to gamescope -- %command%
    args = [
      "-f"
      "-e"
      "--expose-wayland"
      "-W 1920" # 2880
      "-H 1200" # 1800
      "--backend wayland"
      "-C"
      "--force-grab-cursor"
    ];
  };
}
