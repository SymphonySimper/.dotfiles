{ lib, config, ... }:
let
  cfg = config.my.programs.steam;

  args = [
    "-f" # fullscreen
    "-e" # steam integration
    "-W ${builtins.toString cfg.display.width}"
    "-H ${builtins.toString cfg.display.height}"
    "-r ${builtins.toString cfg.display.refreshRate}" # Refresh rate
    # "--expose-wayland"
    # "--backend wayland"
    # "-C" # hide cursor after time delay :smh
    # "--force-grab-cursor"
  ];
in
{
  options.my.programs.steam = {
    enable = lib.mkEnableOption "steam";
    display = lib.mkOption {
      description = "Display settings to be used in gamescope";
      default = { };
      type = lib.types.submodule {
        options = {
          width = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Width of the display";
            default = 1920;
          };
          height = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Height of the display";
            default = 1080;
          };
          refreshRate = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Refresh rate fo the display";
            default = 60;
          };
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # Refer: https://nixos.wiki/wiki/Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession = {
        enable = true;
        inherit args;
        # env = {
        #   LD_PRELOAD = "";
        # };
      };
    };

    programs.gamescope = {
      # enable = true;
      capSysNice = false;
      # set launch options to `LD_PRELOAD="" gamescope -- %command%`
      inherit args;
    };
  };
}
