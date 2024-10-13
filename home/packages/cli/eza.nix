{ ... }:
{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraOptions = [
      "--all"
      "--long"
      "--header"
      "--blocksize"
      "--group-directories-first"
    ];
    git = true;
    icons = true;
  };

  home.shellAliases = {
    ezat = "eza --total-size";
    ls = "eza";
    lst = "ezat";
  };
}
