{ config, lib, ... }: {
  config = lib.mkIf config.programs.discord.enable {
    nixpkgs.config.allowUnfreePackages = [
      "discord"
      "discord-unwrapped"
    ];

    programs.discord = {
      settings.SKIP_HOST_UPDATE = true;
    };
  };
}
