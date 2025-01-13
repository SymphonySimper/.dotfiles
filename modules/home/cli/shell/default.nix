{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./bash.nix
    ./starship.nix
    ./zsh.nix
  ];

  options.my.home.shell = {
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Shell aliases";
      default = { };
    };

    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Shell env";
      default = { };
    };
  };

  config = {
    my.home.shell.aliases = rec {
      # general
      q = "exit";
      ka = "killall";
      ## ls
      ls = "ls --almost-all --color=yes --group-directories-first --human-readable";
      lsl = "${ls} -l --size";
      ## misc
      im_light = "${lib.getExe pkgs.ps_mem} -p $(pgrep -d, -u $USER)";
    };

    home = {
      shellAliases = config.my.home.shell.aliases;
      sessionVariables = config.my.home.shell.env;
    };
  };
}
