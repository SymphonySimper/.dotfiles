{ my, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./browser.nix
    ./mpv.nix
    ./music.nix
    ./office.nix
    ./theme.nix

    ./desktop
  ];

  config = lib.mkIf my.gui.enable (
    lib.mkMerge [
      {
        my.programs = {
          browser.enable = lib.mkDefault my.gui.enable;
          music.enable = lib.mkDefault my.gui.enable;
          office.enable = lib.mkDefault my.gui.enable;
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
    ]
  );
}
