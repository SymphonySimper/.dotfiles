{ ... }:
let
  keymaps = [
    {
      action = "gj";
      key = "j";
      mode = [
        "n"
        "x"
      ];
      options.desc = "Move down a screen row";
    }
    {
      action = "gk";
      key = "k";
      mode = [
        "n"
        "x"
      ];
      options.desc = "Move up a screen row";
    }
    {
      action = "j";
      key = "gj";
      mode = [
        "n"
        "x"
      ];
      options.desc = "Move down a physical line";
    }
    {
      action = "k";
      key = "gk";
      mode = [
        "n"
        "x"
      ];
      options.desc = "Move up a physical line";
    }

    {
      action = "<cmd>nohlsearch<CR><Esc>";
      key = "<Esc>";
      mode = "n";
      options.desc = "Clear search highlighting";
    }
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
      action = "\"+P";
      key = "<space>P";
      mode = "x";
      options.desc = "Replace selection with system clipboard";
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
        options = (keymap.options or { }) // {
          silent = true;
        };
      }
    ) keymaps;
  };
}
