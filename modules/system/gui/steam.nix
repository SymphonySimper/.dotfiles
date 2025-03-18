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
    (lib.getExe' pkgs.gamemode "gamemoderun")
    (lib.getExe' config.programs.gamescope.package "gamescope")
    "--adaptive-sync"
    "-f" # full screen
    "--mouse-sensitivity 2" # increase mouse speed
    "--force-grab-cursor"
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

        dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
        remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play

        gamescopeSession.enable = false;
      };

      gamemode.enable = true;
      gamescope = {
        enable = true;
        capSysNice = false;
        args = [ ];
      };
    };

    environment.systemPackages = with pkgs; [
      mangohud

      # Set launch options to mysteamrun %command%`
      (writeShellScriptBin "mysteamrun" # sh
        ''
          additional_args=()
          width="${my.gui.display.string.desktop.width}"
          height="${my.gui.display.string.desktop.height}"
          for arg in "$@"; do
            case "$1" in
              no-ld)
                shift
                export LD_PRELOAD=""
              ;;
              mango)
                shift
                additional_args+=('--mangoapp')
              ;;
              display)
                shift
                width="${builtins.toString cfg.display.width}"
                height="${builtins.toString cfg.display.height}"
              ;;
            esac
          done
          additional_args+=("-W $width")
          additional_args+=("-H $height")

          ${builtins.concatStringsSep " " args} "''${additional_args[@]}" -- "$@"
        ''
      )
    ];
  };
}
