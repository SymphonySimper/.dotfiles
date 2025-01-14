{ ... }:
{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    keymaps =
      [
        # General
        {
          action = ":noh<CR>";
          key = "<esc>";
          mode = "n";
          options.desc = "No highlight";
        }

        # Clipboard
        {
          action = "\"+y<CR>";
          key = "<leader>y";
          mode = [
            "n"
            "v"
          ];
          options.desc = "Copy to system clipboard";
        }
        {
          action = "\"+p<CR>";
          key = "<leader>p";
          mode = [
            "n"
            "v"
          ];
          options.desc = "Copy to system clipboard";
        }

        # File
        {
          action = ":w<CR>";
          key = "<leader>w";
          mode = [
            "n"
            "v"
          ];
          options.desc = "Write";
        }
        {
          action = ":bd<CR>";
          key = "<leader>bd";
          mode = [
            "n"
            "v"
          ];
          options.desc = "Close buffer";
        }
        {
          action = ":q<CR>";
          key = "<leader>q";
          mode = [
            "n"
            "v"
          ];
          options.desc = "Quit";
        }

      ]
      ++
      # Navigation
      (builtins.map
        (key: {
          action = "<C-w>${key}";
          key = "<C-${key}>";
          mode = "n";
          options.desc = "Focus ${key} pane";
        })
        [
          "h"
          "j"
          "k"
          "l"
        ]
      );
  };
}
