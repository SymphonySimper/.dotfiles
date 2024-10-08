{ pkgs, ... }:
{
  imports = [
    ./cmp.nix
    ./colorizer.nix
    ./conform.nix
    ./diffview.nix
    ./harpoon.nix
    ./lazygit.nix
    ./lsp.nix
    ./markview.nix
    ./mini.nix
    ./neo-tree.nix
    ./neorg.nix
    ./noice.nix
    ./rest.nix
    ./telescope.nix
    ./todo-comments.nix
    ./treesitter.nix
    ./trouble.nix
    ./yazi.nix
  ];

  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.helpview-nvim ];
  };
}
