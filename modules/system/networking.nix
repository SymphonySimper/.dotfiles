{ lib, config, ... }:
let
  cfg = config.my.networking;
in
{
  options.my.networking = {
    enable = lib.mkEnableOption "networking";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = "nixos"; # Define your hostname.
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [
          # 80 # 443
          5173
        ];
      };
      hosts = {
        "0.0.0.0" = [
          # Music
          "music.youtube.com"
          "open.spotify.com"

          # Social Media
          "www.facebook.com"
          "www.fb.com"
          "www.instagram.com"
          "www.twitch.tv"
          "www.twitter.com"
          "www.youtube.com"

          # OTT
          "www.hotstar.com"
          "www.primevideo.com"
          "www.sonyliv.com"
          "www.sunnxt.com"
          "www.zee5.com"
          ## Anime
          "hianime.to"
          "www.crunchyroll.com"

          # Misc
          "store.steampowered.com"
        ];
      };
    };
  };
}
