{ userSettings, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = userSettings.name.name;
    userEmail = "50240805+SymphonySimper@users.noreply.github.com";
    includes = [
      {
        condition = "gitdir:~/${userSettings.dirs.lifeisfun}/work/";
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
      core.editor = userSettings.programs.editor;
      merge.tool = if userSettings.programs.editor == "nvim" then "nvimdiff" else "";
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
}
