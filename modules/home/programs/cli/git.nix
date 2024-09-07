{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = config.my.user.fullName;
    userEmail = "50240805+SymphonySimper@users.noreply.github.com";
    includes = [
      {
        condition = "gitdir:~/${config.my.directory.dev.path}/work/";
        contents = {
          user = {
            name = "Sri Senthil Balaji J";
            email = "176003709+smollan-sri-senthil-balaji@users.noreply.github.com";
          };
          init.defaultBranch = "main";
        };
      }
    ];
    extraConfig = {
      init.defaultBranch = "master";
      core.editor = config.my.program.editor;
      merge.tool = if config.my.program.editor == "nvim" then "nvimdiff" else "";
      push.autoSetupRemote = true;
      mergetool.keepBackup = false;
      pull.rebase = true;
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
    };
  };

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
      };
    };
  };

  home.packages = with pkgs; [
    gh
    git-quick-stats
    git-filter-repo
  ];

  home.shellAliases = {
    ## git
    g = "git";
    gc = "git clone";
    gs = "git status";
    ga = "git add";
    gm = "git commit";
    gp = "git pull";
    gpo = "git pull origin";
    gP = "git push";
    gPF = "git push --force-with-lease";
    gS = "git stash";
    gSp = "git stash pop";
    gb = "git branch";
    gce = "git checkout";
    gsh = "git switch";
    gR = "git reset --hard HEAD";
    gcln = "git clean -fdx";
    gz = "lazygit";
  };
}
