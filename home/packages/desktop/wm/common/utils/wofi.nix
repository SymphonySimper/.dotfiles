{ my, ... }:
{
  programs.wofi = {
    enable = my.programs.launcher == "wofi";
  };
}
