{
  config,
  my,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vcs;

  mkSSHClone =
    {
      host ? "github.com",
      user ? null,
    }:
    let
      suffix = if user == null then "\${1}" else "${user}/\${1}";
    in
    "!fc() { git clone git@${host}:${suffix}; }; fc";
in
{
  imports = [
    (lib.modules.mkAliasOptionModule [ "my" "programs" "vcs" "root" ] [ "programs" "git" ])
  ];

  options.my.programs.vcs =
    (lib.my.mkCommandOption {
      category = "VCS";
      command = "git";
    })
    // {
      sshHost = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "Host for different profiles";
        readOnly = true;
        default = {
          default = "github";
          work = "work-github";
        };
      };

      tui = (
        lib.my.mkCommandOption {
          category = "VCS TUI";
          command = "lazygit";
          args.path = "-p";
        }
      );
    };

  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        git-filter-repo
        git-quick-stats
      ];

      my.programs.editor.ignore = [
        # do not ignore
        "!.gitignore"
        "!.gitattributes"
      ];

      programs.git = {
        enable = true;

        ignores = [
          "node_modules"
        ];

        settings = {
          user = {
            name = my.fullName;
            email = "50240805+SymphonySimper@users.noreply.github.com";
          };

          init.defaultBranch = "main";
          core.editor = config.my.programs.editor.command;

          push.autoSetupRemote = true;
          mergetool.keepBackup = false;
          pull.rebase = true;
          rebase.autoStash = true;

          merge = {
            tool = if config.my.programs.editor.command == "nvim" then "nvimdiff" else "";
            conflictStyle = "zdiff3";
          };

          rerere = {
            enabled = true;
            autoUpdate = true;
          };

          # NOTE: Aliases seems to be Case-insensitive
          # (i.e) `p` == `P`
          alias = {
            c = "clone";
            cs = mkSSHClone { };
            csp = mkSSHClone {
              host = cfg.sshHost.default;
              user = my.fullName;
            };
            cw = mkSSHClone { host = cfg.sshHost.work; };

            s = "status";
            a = "add";
            m = "commit";

            p = "pull";
            po = "pull origin";

            pu = "push";
            puf = "push --force-with-lease";

            st = "stash";
            stp = "stash pop";

            b = "branch";
            ce = "checkout";
            sw = "switch";

            r = "reset";
            rh = "reset --hard HEAD";
            ro = "!git reset --hard origin/$(git branch --show-current)";

            f = "fetch";
            fpa = "fetch --prune --all";

            # misc
            cln = "clean -fdx";

            # shell
            do = "!git fetch && git diff origin";
            z = "!${cfg.tui.command}";
          };
        };

        lfs.enable = true;
      };
    }

    {
      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;

          options = {
            navigate = true;
            side-by-side = true;
            line-numbers = true;
          };
        };

        git.settings.merge.conflictStyle = "zdiff3";
        bat.enable = config.programs.delta.enable;
      };
    }

    {
      programs.lazygit = {
        enable = true;

        settings = {
          git = {
            disableForcePushing = true;
          };

          gui = {
            showBottomLine = false;
            showPanelJumps = false;
            nerdFontsVersion = "3";
            useHunkModeInStagingView = false;
          };
        };
      };
    }
  ];
}
