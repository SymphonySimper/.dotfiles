{ ... }:
let
  keymaps = [
    {
      action = "\"+y";
      key = "<leader>y";
      options.desc = "Yank to system clipboard";
    }
    {
      action = "\"+p";
      key = "<leader>p";
      options.desc = "Paste from system clipboard";
    }
    {
      action = "\"+_dP";
      key = "<space>r";
      options.desc = "Replace selection with system clipboard";
    }

    {
      action = ":write<CR>";
      key = "<leader>bw";
      options.desc = "Save file";
    }
    {
      action = ":bdelete<CR>";
      key = "<leader>bd";
      options.desc = "Close the current buffer";
    }
    {
      action = ":bdelete!<CR>";
      key = "<leader>bD";
      options.desc = "Force close the current buffer";
    }

    {
      action = ":quit<CR>";
      key = "<leader>wq";
      options.desc = "Quit";
    }

    {
      action = "<C-w>k";
      key = "<leader>wk";
      options.desc = "Move to top window";
    }
    {
      action = "<C-w>l";
      key = "<leader>wl";
      options.desc = "Move to right window";
    }
    {
      action = "<C-w>j";
      key = "<leader>wj";
      options.desc = "Move to bottom window";
    }
    {
      action = "<C-w>h";
      key = "<leader>wh";
      options.desc = "Move to left window";
    }

    {
      action = "<C-w>H";
      key = "<leader>wH";
      options = {
        remap = true;
        desc = "Move pane far left";
      };
    }
    {
      action = "<C-w>J";
      key = "<leader>wJ";
      options = {
        remap = true;
        desc = "Move pane far bottom";
      };
    }
    {
      action = "<C-w>K";
      key = "<leader>wK";
      options = {
        remap = true;
        desc = "Move pane far top";
      };
    }
    {
      action = "<C-w>L";
      key = "<leader>wL";
      options = {
        remap = true;
        desc = "Move pane far right";
      };
    }

    {
      action = ":resize +2<CR>";
      key = "<leader>wrk";
      options.desc = "Resize top";
    }
    {
      action = ":vertical resize +2<CR>";
      key = "<leader>wrl";
      options.desc = "Resize right";
    }
    {
      action = ":resize -2<CR>";
      key = "<leader>wrj";
      options.desc = "Resize bottom";
    }
    {
      action = ":vertical resize -2<CR>";
      key = "<leader>wrh";
      options.desc = "Resize left";
    }
  ];
in
{
  programs.nixvim = {
    globals = rec {
      mapleader = " ";
      maplocalleader = mapleader;
    };

    keymaps = map (
      keymap:
      keymap
      // {
        mode =
          if (keymap ? mode) then
            keymap.mode
          else
            [
              "n"
              "v"
            ];
        options.silent = true;
      }
    ) keymaps;
  };
}
