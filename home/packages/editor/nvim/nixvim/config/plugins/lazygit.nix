{ myUtils, ... }:
{
  programs.nixvim = {
    plugins.lazygit = {
      enable = true;
      gitPackage = null;

    };

    keymaps = myUtils.mkKeymaps [
      [
        "<CMD>LazyGit<CR>"
        "<leader>gz"
        "n"
        "LazyGit"
      ]
    ];
  };
}
