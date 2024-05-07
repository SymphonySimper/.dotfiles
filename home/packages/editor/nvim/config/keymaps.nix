{ myUtils, ... }:
let
  keymaps = myUtils.mkKeymaps [
    # Genreal
    [ ":noh<CR>" "<esc>" "n" "No highlight" ]

    # Clipboard
    [ "\"+y<CR>" "<leader>y" [ "n" "v" ] "Copy to system clipboard" ]
    [ "\"+p<CR>" "<leader>p" [ "n" "v" ] "Copy to system clipboard" ]

    # File
    [ ":w<CR>" "<leader>w" [ "n" "v" ] "Write" ]
    [ ":bd<CR>" "<leader>bd" [ "n" "v" ] "Close buffer" ]
    [ ":q<CR>" "<leader>q" [ "n" "v" ] "Quit" ]

    # Navigation
    [ "<C-w>h" "<C-h>" "n" "Focus left pane" ]
    [ "<C-w>l" "<C-l>" "n" "Focus right pane" ]
    [ "<C-w>k" "<C-k>" "n" "Focus up pane" ]
    [ "<C-w>j" "<C-j>" "n" "Focus down pane" ]
  ];
in
{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    keymaps = keymaps;
  };
}
