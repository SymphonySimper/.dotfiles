{ pkgs, ... }:
{
  imports = [
    ./cmp.nix
    ./colorizer.nix
    ./conform.nix
    ./harpoon.nix
    ./lazygit.nix
    ./lsp.nix
    ./markview.nix
    ./mini.nix
    ./neorg.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
  ];

  programs.nixvim = {
    extraPlugins = [ pkgs.nvimPlugins.helpview ];
  };
}
