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
      home.packages = with pkgs; [
        bc # calculator
        killall

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
    }

    {
      services.tldr-update = {
        enable = true;
        package = pkgs.tlrc;
        period = "weekly";
      };

      xdg.configFile."tlrc/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
        cache = {
          dir = "${config.xdg.cacheHome}/tldr";
          mirror = "https://github.com/tldr-pages/tldr/releases/latest/download";
          auto_update = false;
        };
      };

      home.packages = [ config.services.tldr-update.package ];
    }

    (
      let
        defaultEnv = "FZF_DEFAULT_OPTS";
      in
      {
        programs.fzf = {
          enable = true;
          defaultOptions = [ "--reverse" ];
        };

        my.programs.shell.nu.envVar.${defaultEnv} = config.my.programs.shell.env.${defaultEnv};
      }
    )

    {
      programs = {
        fd.enable = true;
        ripgrep.enable = true;
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
