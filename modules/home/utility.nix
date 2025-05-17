{ pkgs, lib, ... }:
{
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        bc # calculator
        killall
        wl-clipboard

        # web
        curl
        wget
      ];
    }

    {
      programs.man = {
        enable = true;
        generateCaches = true;

      };

      home.packages = [
        pkgs.tlrc # tldr
      ];
    }

    {
      programs = {
        fzf = {
          enable = true;
          defaultOptions = [
            "--reverse"
          ];
        };

        fd.enable = true;
        jq.enable = true;
        ripgrep.enable = true;
      };
    }
  ];
}
