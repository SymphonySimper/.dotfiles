{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.networking;

  begone = rec {
    allowed = {
      discord = [
        "discord.com"
        "discord.gg"
        "discordapp.com"
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

      music = [
        "music.youtube.com"
        "open.spotify.com"
      ];

      ott = [
        "www.hotstar.com"
        "www.primevideo.com"
        "www.sonyliv.com"
        "www.sunnxt.com"
        "www.zee5.com"
        "netflix.com"
      ];

      reddit = [
        "www.reddit.com"
        "ol.reddit.com"
      ];

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
  };
in
{
  options.my.networking = {
    enable = lib.mkEnableOption "networking";

    begone = {
      enable = lib.mkEnableOption "Begone";

      allow = lib.mkOption {
        type = lib.types.submodule {
          options = lib.attrsets.genAttrs (builtins.attrNames begone.default) (name: lib.mkEnableOption name);
        };
        description = "Unblock sites that are blocked by default";
      };

      sites = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Begone sites";
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    my = {
      user.sudo.nopasswd = [ "${config.my.user.bin}/systemctl restart NetworkManager" ];

      networking.begone = {
        allow = builtins.mapAttrs (
          name: _: lib.mkDefault (builtins.elem name (builtins.attrNames begone.allowed))
        ) begone.default;

        sites = lib.lists.flatten (
          builtins.map (host: lib.optionals (!cfg.begone.allow.${host.name}) host.value) (
            lib.attrsToList begone.default
          )
        );
      };
    };

    networking = {
      hostName = lib.mkDefault my.profile;
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;

      firewall = {
        enable = true;
        allowedTCPPorts = [
          5173 # vite
        ];
      };

      hosts = lib.mkIf cfg.begone.enable { "0.0.0.0" = lib.lists.unique cfg.begone.sites; };
    };
  };
}
