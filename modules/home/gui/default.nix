{
  my,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./browser.nix
    ./mpv.nix
    ./theme.nix

    ./desktop
  ];

  config = lib.mkIf my.gui.enable (
    lib.mkMerge [
      {
        programs.zathura.enable = true;
        my.desktop.mime."org.pwmt.zathura" = [
          "application/pdf"
        ];

        home.packages = with pkgs; [
          libreoffice
          qbittorrent
        ];
      }

      (lib.mkIf (my.programs.music == "spotify") {
        home.packages = [ pkgs.spotify ];
        my.desktop.automove = [
          [
            "spotify.desktop"
            6
          ]
        ];
      })
    ]
  );
}
