{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "SymphonySimper";
    userEmail = "50240805+SymphonySimper@users.noreply.github.com";
    includes = [
      {
        condition = "gitdir:~/lifeisfun/work/";
        contents = {
          user = {
            name = "Sri Senthil Balaji J";
          };
          init.defaultBranch = "main";
        };
      }
    ];
    extraConfig = {
      init.defaultBranch = "master";
      core.editor = "nvim";
      merge.tool = "nvimdiff";
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
  ];
}
