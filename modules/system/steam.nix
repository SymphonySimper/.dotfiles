{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.steam;
in
{
  options.my.programs.steam = {
    enable = lib.mkEnableOption "Steam";
    display = lib.mkOption {
      description = "Display settings to be used in gamescope and other games";
      default = { };
      type = lib.types.submodule {
        options = {
          vrr = lib.mkEnableOption "Adaptive Sync";

          width = lib.mkOption {
            type = lib.types.nullOr lib.types.numbers.positive;
            description = "Width of the display";
            default = my.gui.display.width;
          };

          height = lib.mkOption {
            type = lib.types.nullOr lib.types.numbers.positive;
            description = "Height of the display";
            default = my.gui.display.height;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    my = {
      networking.begone.allow.steam = true;
      programs.steam.display.vrr = lib.mkDefault my.gui.display.vrr;
    };

    programs = {
      steam = {
        enable = true;

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
        args = builtins.concatLists [
          [
            "-f" # full screen
            "--mouse-sensitivity 1" # increase mouse speed
            "--force-grab-cursor"
          ]

          (lib.optionals cfg.display.vrr [ "--adaptive-sync" ])
          (lib.optionals (cfg.display.width != null) [
            "-W ${builtins.toString cfg.display.width}"
          ])
          (lib.optionals (cfg.display.height != null) [ "-H ${builtins.toString cfg.display.height}" ])
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      # `mangohud %command%`
      mangohud
    ];
  };
}
