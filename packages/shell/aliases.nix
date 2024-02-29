{
  shellAliases = {
    # general
    q = "exit";

    # git
    g = "git";
    gc = "git clone";
    gs = "git status";
    ga = "git add";
    gm = "git commit";
    gP = "git push";
    gp = "git pull";
    gb = "git branch";
    gce = "git checkout";
    gsh = "git switch";
    gcln = "git clean -fdxX";
    gz = "lazygit";

    # python
    py = "python";
    ca = "conda activate";

    # home-manager;
    hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake .";
  };
}
