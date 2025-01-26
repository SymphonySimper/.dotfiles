{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.gaming;

  sessionArgs = [
    "--mouse-sensitivity 2" # increase mouse speed
    "--adaptive-sync"
  ];

  args = sessionArgs ++ [
    # "--force-grab-cursor"
    "-f" # full screen
    "-e" # steam integration
    "-W ${builtins.toString cfg.display.width}"
    "-H ${builtins.toString cfg.display.height}"
  ];
in
{
  options.my.programs.gaming = {
    enable = lib.mkEnableOption "Gaming";
    display = lib.mkOption {
      description = "Display settings to be used in gamescope and other games";
      default = { };
      type = lib.types.submodule {
        options = {
          width = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Width of the display";
            default = my.gui.display.width;
          };
          height = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Height of the display";
            default = my.gui.display.height;
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
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        gamescopeSession = {
          enable = true;
          args = sessionArgs;
        };
      };

      gamemode.enable = true;
      gamescope = {
        enable = true;
        capSysNice = false;
        # Set launch options to `LD_PRELOAD="" gamescope -- %command%`
        # to launch with mangohud use `gamescope --mangoapp -- %command%`
        inherit args;
      };
    };

    environment.systemPackages = [ pkgs.mangohud ];
    my.programs.tty."2" = {
      skipUsername = true;
      launch = {
        command = "steam-gamescope";
        dbus = true;
      };
    };
  };
}
