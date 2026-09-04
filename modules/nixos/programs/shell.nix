{ ... }: {
  programs.command-not-found.enable = false;

  programs.bash = {
    enableLsColors = false;
    completion.enable = true;
  };
}
