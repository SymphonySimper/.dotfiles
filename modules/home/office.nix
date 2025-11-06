{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.office.enable = lib.mkEnableOption "Office";

  config = lib.mkIf config.my.programs.office.enable {
    home.packages = with pkgs; [ libreoffice ];
  };
}
