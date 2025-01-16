{ ... }:
{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nixvim.plugins.direnv.enable = true;
  };
}
