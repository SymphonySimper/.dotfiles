{ lib, ... }:
{
  programs.nixvim = {
    plugins.yazi.enable = true;
    keymaps = lib.my.mkKeymaps [
      [
        "<cmd>Yazi<cr>"
        "<leader>fy"
        "n"
        "Open yazi at the current file"
      ]
    ];
  };
}
