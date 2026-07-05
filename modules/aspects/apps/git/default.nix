{ den, lib, ... }: {

  den.default.includes = [ den.aspects.options.apps.git.user ];

  den.aspects.options.apps.git.user = {
    homeManager.options.programs.git = {
      user = lib.mkOption {
        description = "Git user config";
        type = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Username";
            };

            email = lib.mkOption {
              type = lib.types.str;
              description = "Email";
            };
          };
        };
      };
    };
  };

  den.aspects.apps.git = {
    homeManager = { config, pkgs, ... }: {
      imports = [ ./_profiles.nix ];

      home.packages = [ pkgs.git-filter-repo ];

      programs.helix.ignores = [
        "!.gitignore"
        "!.gitattributes"
      ];

      programs.git = {
        enable = true;
        lfs.enable = true;

        signing = {
          format = lib.mkDefault null;
        };

        settings = {
          user = config.programs.git.user;

          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          mergetool.keepBackup = false;
          pull.rebase = true;
          rebase.autoStash = true;
          merge.conflictStyle = "zdiff3";

          rerere = {
            enabled = true;
            autoUpdate = true;
          };

          alias = rec {
            d = "diff";
            p = "pull";
            pu = "push";

            # add
            a = "add";
            ap = "${a} -p";

            # commit
            c = "commit";
            cm = "${c} -m";
            cp = "${c} -p";
            cpm = "${cp} -m";

            # status
            s = "status";
            sv = "${s} -v";

            # log
            lo = "log --graph --oneline";
            l = "${lo} -8";

            # branch
            sw = "switch";
            b = "branch --verbose --verbose";
            fpa = "fetch --prune --all";
          };
        };
      };
    };
  };
}
