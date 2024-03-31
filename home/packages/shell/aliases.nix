{
  shellAliases = {
    # general
    q = "exit";
    ka = "killall";
    ## eza
    eza = "eza --all --long --header --blocksize --group-directories-first";
    ezat = "eza --total-size";
    ls = "eza";
    lst = "ezat";
    ## misc
    im_light = "ps_mem -p $(pgrep -d, -u $USER)";

    # dev
    ## Nix;
    snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake .#system";
    ### home-manager;
    hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake .";
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
    gen_ssh = "ssh-keygen -t ed25519 -C \"$(git config --get user.email)\"";
    ## rust
    rc = "cargo";
    rcn = "cargo new";
    rca = "cargo add";
    rcr = "cargo run";
    rct = "cargo test";
    ## python
    py = "python";
    pc = "conda";
    pca = "conda activate";
    ## js
    jp = "pnpm";
    jpi = "pnpm i";
    jprd = "pnpm run dev --open";
    jpf = "pnpm format";
  };
}
