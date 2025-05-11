{ lib, config, ... }:
let
  cfg = config.my.networking.begone;

  allowed = {
    discord = [
      "discord.com"
      "discord.gg"
      "discordapp.com"
    ];

    music = [
      "music.youtube.com"
      "open.spotify.com"
    ];
  };

  denied = {

    anime = [
      "hianime.to"
      "www.crunchyroll.com"
    ];

    fb = [
      "www.facebook.com"
      "www.fb.com"
    ];

    insta = [ "www.instagram.com" ];

    ott = [
      "www.hotstar.com"
      "www.primevideo.com"
      "www.sonyliv.com"
      "www.sunnxt.com"
      "www.zee5.com"
      "netflix.com"
    ];

    reddit = [ "www.reddit.com" ];

    steam = [
      "store.steampowered.com"
      "steamcommunity.com"
    ];

    twitch = [ "www.twitch.tv" ];
    twitter = [
      "www.twitter.com"
      "x.com"
    ];

    yt = [ "www.youtube.com" ];
  };

  default = allowed // denied;
in
{
  options.my.networking.begone = {
    enable = lib.mkEnableOption "Begone";
    allow = lib.mkOption {
      type = lib.types.submodule {
        options = lib.attrsets.genAttrs (builtins.attrNames default) (name: lib.mkEnableOption name);
      };
      description = "Unblock sites that are blocked by default";
    };

    sites = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Begone sites";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    my.networking.begone = {
      allow = builtins.mapAttrs (
        name: _: lib.mkDefault (builtins.elem name (builtins.attrNames allowed))
      ) default;

      sites = lib.lists.flatten (
        builtins.map (host: lib.optionals (!cfg.allow.${host.name}) host.value) (lib.attrsToList default)
      );
    };

    networking.hosts."0.0.0.0" = lib.lists.unique cfg.sites;
  };
}
