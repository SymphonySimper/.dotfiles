{ ... }:
{
  imports = [ ./config/default.nix ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withNodeJs = false;
    withRuby = false;
  };
}
