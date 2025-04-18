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
        programs.obs-studio.enable = true;
        my.desktop.windows = [
          {
            id = "com.obsproject.Studio";
            workspace = 9;
          }
        ];
      }

      {
        programs.zathura.enable = true;
        my.desktop = {
          mime."org.pwmt.zathura" = [
            "application/pdf"
          ];

          windows = [
            {
              id = "org.pwmt.zathura";
              workspace = 4;
            }
          ];
        };
      }

      {
        home.packages = with pkgs; [ libreoffice ];
      }
    ]
  );
}
