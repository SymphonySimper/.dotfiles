{
  config,
  my,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    git-filter-repo
  ];

  programs = {
    git = {
      enable = true;
      userName = my.fullName;
      userEmail = "50240805+SymphonySimper@users.noreply.github.com";

      includes = [
        {
          condition = "gitdir:${my.dir.dev}/work/";
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

      aliases = {
        c = "clone";
        s = "status";
        a = "add";
        m = "commit";
        p = "pull";
        po = "pull origin";
        P = "push";
        PF = "push --force-with-lease";
        S = "stash";
        Sp = "stash pop";
        b = "branch";
        ce = "checkout";
        sw = "switch";
        cln = "clean -fdx";
        R = "reset --hard HEAD";
        Ro = "!git reset --hard origin/$(git branch --show-current)";
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
        };
      };
    };

    bat.enable = config.programs.git.delta.enable;

    helix.grammars = [
      "gitignore"
      "git-commit"
      "git-config"
      "git-rebase"
      "gitattributes"
    ];
  };
}
