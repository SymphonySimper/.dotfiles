{ pkgs, ... }:
{
  imports = [ ./config/default.nix ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      fd
      gcc
      ripgrep
    ];
  };
}
