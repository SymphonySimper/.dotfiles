{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.clipboard = {
    enable = lib.mkEnableOption "Clipboard";
  };

  config = lib.mkIf config.programs.clipboard.enable {
    home.packages = [ pkgs.wl-clipboard ];
  };
}
