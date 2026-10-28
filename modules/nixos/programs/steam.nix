{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.programs.steam.enable {
    nixpkgs.config.allowUnfreePackages = [
      "steam"
      "steam-unwrapped"
    ];

    programs = {
      steam = {
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;

        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      gamescope = {
        enable = true;
        args = [
          "--fullscreen"
          "--force-grab-cursor"
        ];
      };
    };

    environment = {
      sessionVariables.PROTON_ENABLE_WAYLAND = 1;

      systemPackages = [
        pkgs.mangohud

        # Avoid Steam's LD_PRELOAD causing Gamescope to stutter after about 24 minutes.
        (pkgs.writeShellScriptBin "mygamescope" ''
          LD_PRELOAD="" exec gamescope "$@"
        '')
      ];
    };
  };
}
