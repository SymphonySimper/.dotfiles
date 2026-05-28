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

        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play

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
          "--rt" # use realtime scheduling
          "--fullscreen"
          "--force-grab-cursor"
          "--immediate-flips" # tearing
        ];
      };
    };

    environment = {
      sessionVariables = {
        PROTON_ENABLE_WAYLAND = 1;
        SDL_VIDEO_DRIVER = "wayland";
        SDL_VIDEO_WAYLAND_SCALE_TO_DISPLAY = 1;
      };

      systemPackages = [
        # `mangohud %command%`
        pkgs.mangohud
      ];
    };
  };
}
