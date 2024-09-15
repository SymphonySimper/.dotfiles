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
    ./noice.nix
    ./telescope.nix
    ./todo-comments.nix
    ./treesitter.nix
    ./trouble.nix
  ];

  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.helpview-nvim ];
  };
}
