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

  home.packages = with pkgs; [
    gh
  ];
}
