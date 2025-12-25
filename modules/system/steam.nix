{
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
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;

        dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
        remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play

        gamescopeSession.enable = false;

        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      # `gamescope -- %command%`
      # for mangohud `gamescope --mangoapp -- %command%`
      # for LD_PRELOAD `LD_PRELOAD="" gamescope -- %command%`
      gamescope = {
        enable = true;
        capSysNice = false;
        args = [
          "-f" # full screen
          "--mouse-sensitivity 1" # increase mouse speed
          "--force-grab-cursor"
          "--adaptive-sync"
        ];
      };
    };

    environment = {
      sessionVariables.PROTON_ENABLE_WAYLAND = 1;

      systemPackages = with pkgs; [
        # `mangohud %command%`
        mangohud
      ];
    };
  };
}
