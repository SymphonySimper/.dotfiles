{ config, lib, ... }: {
  config = lib.mkIf config.programs.discord.enable {
    nixpkgs.config.allowUnfreePackages = [
      "discord"
      "discord-unwrapped"
    ];

    programs.discord = {
      # Keep in sync with nixpkgs' disable-breaking-updates.py, which rewrites
      # settings.json (replacing the HM symlink) if any of these are missing.
      settings = {
        SKIP_HOST_UPDATE = true;
        SKIP_MODULE_UPDATE = true;
        MINIMIZE_TO_TRAY = false;
      };
    };
  };
}
