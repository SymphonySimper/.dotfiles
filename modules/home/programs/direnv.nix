{ ... }: {
  programs.direnv = {
    nix-direnv.enable = true;

    silent = false;
    config.warn_timeout = "2m";
  };

  programs.git.ignores = [ ".direnv" ];
  programs.helix.ignores = [ "!.envrc" ];
}
