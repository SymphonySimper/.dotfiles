{ ... }:
{
  my = {
    wsl.enable = true;

    programs = {
      yazi.enable = true;

      shell = {
        bash.enable = true;
        fish.enable = true;
        nushell.enable = true;
      };
    };
  };
}
