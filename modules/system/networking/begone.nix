{ lib, config, ... }:
let
  cfg = config.my.networking.begone;
in
{
  options.my.networking.begone = {
    enable = lib.mkEnableOption "Begone";
    sites = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Begone sites";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    my.networking.begone.sites = [
      # Music
      # "music.youtube.com"
      # "open.spotify.com"

      # Social Media
      # "discord.com"
      # "discord.gg"
      # "discordapp.com"
      "www.facebook.com"
      "www.fb.com"
      "www.instagram.com"
      "www.twitch.tv"
      "www.twitter.com"
      "www.youtube.com"
      "x.com"

      # OTT
      "www.hotstar.com"
      "www.primevideo.com"
      "www.sonyliv.com"
      "www.sunnxt.com"
      "www.zee5.com"
      ## Anime
      "hianime.to"
      # "www.crunchyroll.com"

      # Misc
      # "store.steampowered.com"
    ];

    networking.hosts."0.0.0.0" = lib.lists.unique cfg.sites;
  };
}
