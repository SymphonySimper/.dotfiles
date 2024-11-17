{ my, ... }:
{
  programs.zathura = {
    enable = my.programs.pdf == "zathura";
  };
}
