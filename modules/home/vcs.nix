{
  config,
  my,
  pkgs,
  ...
}:
let
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
  home.packages = with pkgs; [
    git-filter-repo
    git-quick-stats
  ];

  programs = {
    git = {
      enable = true;
      userName = my.fullName;
      userEmail = "50240805+SymphonySimper@users.noreply.github.com";

      includes = [
        {
          condition = "gitdir:${my.dir.work}/";
          contents = {
            user = {
              name = "Sri Senthil Balaji J";
              email = "176003709+smollan-sri-senthil-balaji@users.noreply.github.com";
            };
          };
        }
      ];

      ignores = [
        "node_modules"
      ];

      extraConfig = {
        init.defaultBranch = "main";
        core.editor = my.programs.editor;
        push.autoSetupRemote = true;
        mergetool.keepBackup = false;
        pull.rebase = true;
        rebase.autoStash = true;

        merge = {
          tool = if my.programs.editor == "nvim" then "nvimdiff" else "";
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
        csp = mkSSHClone { user = my.fullName; };
        cw = mkSSHClone { host = "work-github"; };

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
        z = "!lazygit";
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
}
