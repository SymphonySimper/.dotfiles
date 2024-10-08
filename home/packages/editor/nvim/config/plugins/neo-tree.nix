{ lib, ... }:
{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      closeIfLastWindow = true;
      filesystem = {
        hijackNetrwBehavior = "disabled";
        bindToCwd = false;
      };
    };

    keymaps = (
      lib.my.mkKeymaps [
        [
          {
            __raw = ''
              function()
                require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand('%:p:h') })
              end'';
          }
          "<leader>fe"
          "n"
          "Explorer NeoTree (Directory of Current File)"
        ]
        [
          {
            __raw = ''
              function()
                require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
              end'';
          }
          "<leader>fE"
          "n"
          "Explorer NeoTree (cwd)"
        ]
      ]
    );
  };
}
