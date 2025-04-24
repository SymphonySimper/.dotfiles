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
        my.programs = {
          browser.enable = lib.mkDefault my.gui.enable;
        };
      }

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
        home.packages = [ pkgs.bitwarden-desktop ];
        my.desktop.windows = [
          {
            id = "Bitwarden";
            workspace = 8;
          }
        ];
      }

      {
        home.packages = with pkgs; [ libreoffice ];
      }
    ]
  );
}
