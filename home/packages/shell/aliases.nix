{ ... }:
{
  home.shellAliases = {
    # general
    q = "exit";
    ka = "killall";
    ## eza
    ezat = "eza --total-size";
    ls = "eza";
    lst = "ezat";
    ## misc
    im_light = "ps_mem -p $(pgrep -d, -u $USER)";

    # dev
    ## Nix;
    snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake";
    nix_flake_update = "nix flake update --commit-lock-file";
    ### home-manager;
    hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake";
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
    ## rust
    rc = "cargo";
    rcn = "cargo new";
    rca = "cargo add";
    rcr = "cargo run";
    rct = "cargo test";
    ## python
    py = "python";
    pc = "micromamba";
    pca = "micromamba activate";
    pcd = "micromamba deactivate";
    pcce = "micromamba create -n";
    pcrm = "micromamba env remove -n";
    pfrd = "flask run --debug";
    ## js
    jp = "pnpm";
    jpi = "pnpm i";
    jprd = "pnpm run dev";
    jpf = "pnpm format";
    jn = "npm";
    jni = "npm i";
    jnrd = "npm run dev";
    jnf = "npm run format";
    ## docker
    docker_cln = "docker system prune --volumes";
  };
}
