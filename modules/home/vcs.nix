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

  options.my.programs.vcs = {
    sshHost = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Host for different profiles";
      readOnly = true;
      default = {
        default = "github";
        work = "work-github";
      };
    };

    tui = (lib.my.mkCommandOption "VCS TUI" "lazygit") // {
      args.path = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "-p";
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      git-filter-repo
      git-quick-stats
    ];

    programs = {
      git = {
        enable = true;
        userName = my.fullName;
        userEmail = "50240805+SymphonySimper@users.noreply.github.com";

        ignores = [
          "node_modules"
        ];

        extraConfig = {
          init.defaultBranch = "main";
          core.editor = config.my.programs.editor.command;
          push.autoSetupRemote = true;
          mergetool.keepBackup = false;
          pull.rebase = true;
          rebase.autoStash = true;

          merge = {
            tool = if config.my.programs.editor.command == "nvim" then "nvimdiff" else "";
            conflictStyle = "zdiff3"; # delta
          };

          rerere = {
            enabled = true;
            autoUpdate = true;
          };
        };

        delta = {
          enable = true;
          options = {
            navigate = true;
            side-by-side = true;
            line-numbers = true;
          };
        };

        lfs.enable = true;

        # NOTE: Aliases seems to be Case-insensitive
        # (i.e) `p` == `P`
        aliases = {
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

      lazygit = {
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

      bat.enable = config.programs.git.delta.enable;

    };

    my.programs.editor.ignore = [
      # do not ignore
      "!.gitignore"
      "!.gitattributes"
    ];
  };
}
