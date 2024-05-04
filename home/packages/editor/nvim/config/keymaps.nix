{ ... }:
let
  keymaps = map
    (keymap: {
      action = builtins.elemAt keymap 0;
      key = builtins.elemAt keymap 1;
      mode = builtins.elemAt keymap 2;
      options.desc = builtins.elemAt keymap 3;
    }) [
    # Genreal
    [ ":noh<CR>" "<esc>" "n" "No highlight" ]

    # Clipboard
    [ "\"+y<CR>" "<leader>y" [ "n" "v" ] "Copy to system clipboard" ]
    [ "\"+p<CR>" "<leader>p" [ "n" "v" ] "Copy to system clipboard" ]

    # File
    [ ":w<CR>" "<leader>w" [ "n" "v" ] "Write" ]
    [ ":wa<CR>" "<leader>wa" [ "n" "v" ] "Write all" ]
    [ ":bd<CR>" "<leader>bd" [ "n" "v" ] "Close buffer" ]
    [ ":q<CR>" "<leader>q" [ "n" "v" ] "Quit" ]
    [ ":qa<CR>" "<leader>qa" [ "n" "v" ] "Quit all" ]

    # Navigation
    [ "<C-w>h" "<leader>h" "n" "Focus left pane" ]
    [ "<C-w>l" "<leader>l" "n" "Focus right pane" ]
    [ "<C-w>k" "<leader>k" "n" "Focus up pane" ]
    [ "<C-w>j" "<leader>j" "n" "Focus down pane" ]
  ];
in
{
  programs.nixvim.keymaps = keymaps;
}
