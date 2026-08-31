{ config, lib, ... }:
let
  cfg = config.networking;
in
{
  options.networking = {
    blockHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Hosts that should be blocked";
      example = [
        "www.youtube.com"
        "www.reddit.com"
        "old.reddit.com"
      ];
    };
  };

  config = lib.mkIf (cfg.blockHosts != [ ]) {
    networking.hosts."0.0.0.0" = lib.lists.unique cfg.blockHosts;
  };
}
