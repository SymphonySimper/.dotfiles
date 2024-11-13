{ lib, ... }:
{
  programs.nixvim = {
    plugins.lazygit = {
      enable = true;
      gitPackage = null;

    };

    keymaps = lib.my.mkKeymaps [
      [
        "<CMD>LazyGit<CR>"
        "<leader>gz"
        "n"
        "LazyGit"
      ]
    ];
  };
}
