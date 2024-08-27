{
  width ? 1920,
  height ? 1080,
  refreshRate ? 60,
  ...
}:
let
  args = [
    "-f" # fullscreen
    "-e" # steam integration
    "-W ${builtins.toString width}"
    "-H ${builtins.toString height}"
    "-r ${builtins.toString refreshRate}" # Refresh rate
    # "--expose-wayland"
    # "--backend wayland"
    # "-C" # hide cursor after time delay :smh
    # "--force-grab-cursor"
  ];
in
{
  # Refer: https://nixos.wiki/wiki/Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession = {
      enable = true;
    };
  };

  programs.gamescope = {
    # enable = true;
    capSysNice = false;
    # set launch options to `env LD_PRELOAD="" gamescope -- %command%`
    inherit args;
  };
}
