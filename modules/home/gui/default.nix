{
  my,
  pkgs,
  lib,
  ...
}:
{
  imports = lib.optionals my.gui.enable (
    lib.my.mkReadDir {
      path = ./.;
      asPath = true;
      ignoreDefault = true;
    }
  );

  config = lib.mkIf my.gui.enable {
    programs.zathura.enable = true;
    my.desktop.mime."org.pwmt.zathura" = [
      "application/pdf"
    ];

    home.packages = with pkgs; [
      libreoffice
      qbittorrent
    ];
  };
}
