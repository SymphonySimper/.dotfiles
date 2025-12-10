{
  my,
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

    {
      programs.btop = {
        enable = true;

        package = pkgs.btop.override {
          # GPU support
          rocmSupport = true; # amd
          cudaSupport = true; # nvida
        };

        settings = {
          vim_keys = true;
          shown_boxes = "cpu mem net proc gpu0";
          update_ms = 2000; # recommended
          proc_tree = false;
        };
      };
    }

    {
      # Clipboard
      home.packages = lib.lists.optional (
        my.gui.enable && pkgs.stdenv.hostPlatform.isLinux
      ) pkgs.wl-clipboard;
    }
  ];
}
