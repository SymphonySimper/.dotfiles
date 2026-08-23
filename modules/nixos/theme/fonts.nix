{ config, lib, ... }:
let
  cfg = config.theme.fonts;
in
{
  options.theme.fonts = {
    enable = lib.mkEnableOption "Fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
    };
  };
}
