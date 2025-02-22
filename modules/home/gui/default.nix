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
    programs = {
      zathura.enable = true;
      obs-studio.enable = true;
    };

    home.packages = with pkgs; [
      libreoffice
      qbittorrent
    ];
  };
}
