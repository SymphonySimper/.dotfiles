{ utils, ... }:
let
  keymaps = utils.mkKeymaps [
    # Genreal
    [ ":noh<CR>" "<esc>" "n" "No highlight" ]

    # Clipboard
    [ "\"+y<CR>" "<leader>y" [ "n" "v" ] "Copy to system clipboard" ]
    [ "\"+p<CR>" "<leader>p" [ "n" "v" ] "Copy to system clipboard" ]

    # File
    [ ":w<CR>" "<leader>w" [ "n" "v" ] "Write" ]
    [ ":bd<CR>" "<leader>c" [ "n" "v" ] "Close buffer" ]
    [ ":q<CR>" "<leader>q" [ "n" "v" ] "Quit" ]

    # Navigation
    [ "<C-w>h" "<leader>h" "n" "Focus left pane" ]
    [ "<C-w>l" "<leader>l" "n" "Focus right pane" ]
    [ "<C-w>k" "<leader>k" "n" "Focus up pane" ]
    [ "<C-w>j" "<leader>j" "n" "Focus down pane" ]
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
