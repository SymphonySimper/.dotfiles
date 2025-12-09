{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [ bc ];
    }

    {
      programs.man = {
        enable = true;
        generateCaches = true;
      };
    }

    {
      programs.fzf = {
        enable = true;
        defaultOptions = [ "--reverse" ];
      };
    }

    # Clipboard
    {
      home.packages = lib.lists.optional (
        my.gui.enable && pkgs.stdenv.hostPlatform.isLinux
      ) pkgs.wl-clipboard;
    }
  ];
}
