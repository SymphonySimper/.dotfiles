{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.steam;

  args = [
    "--adaptive-sync"
    "-f" # full screen
    "--mouse-sensitivity 2" # increase mouse speed
    "--force-grab-cursor"
    "-W ${builtins.toString cfg.display.width}"
    "-H ${builtins.toString cfg.display.height}"
  ];
in
{
  options.my.programs.steam = {
    enable = lib.mkEnableOption "Steam";
    display = lib.mkOption {
      description = "Display settings to be used in gamescope and other games";
      default = { };
      type = lib.types.submodule {
        options = {
          width = lib.mkOption {
            type = lib.types.numbers.positive;
            description = "Width of the display";
            default = my.gui.display.desktop.width;
          };
          height = lib.mkOption {
            type = lib.types.numbers.positive;
            description = "Height of the display";
            default = my.gui.display.desktop.height;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        # Refer: https://nixos.wiki/wiki/Steam
        extest.enable = true;

        dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
        remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play

        gamescopeSession.enable = false;
      };

      # `gamemoderun %command%`
      gamemode.enable = true;

      # `gamescope -- %command%`
      # for mangohud `gamescope --mangoapp -- %command%`
      # for LD_PRELOAD `LD_PRELOAD="" gamescope -- %command%`
      gamescope = {
        enable = true;
        capSysNice = false;
        inherit args;
      };
    };

    environment.systemPackages = with pkgs; [
      # `mangohud %command%`
      mangohud
    ];
  };
}
