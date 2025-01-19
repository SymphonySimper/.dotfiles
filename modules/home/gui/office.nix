{
  pkgs,
  lib,
  my,
  ...
}:
{
  config = lib.mkIf my.gui.enable {
    programs.zathura.enable = true;
    home.packages = with pkgs; [ libreoffice ];
  };
}
