{ lib, ... }:
{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings = {
        auto_close = true;
        use_diagnostic_signs = true;
      };
    };

    keymaps = lib.my.mkKeymaps [
      [
        "<cmd>Trouble diagnostics toggle<cr>"
        "<leader>xx"
        "n"
        "Diagnostics (Trouble)"
      ]
      [
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"
        "<leader>xX"
        "n"
        "Buffer Diagnostics (Trouble)"
      ]
      [
        "<cmd>Trouble symbols toggle focus=false<cr>"
        "<leader>cs"
        "n"
        "Symbols (Trouble)"
      ]
      [
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>"
        "<leader>cl"
        "n"
        "LSP Definitions / references / ... (Trouble)"
      ]
      [
        "<cmd>Trouble loclist toggle<cr>"
        "<leader>xL"
        "n"
        "Location List (Trouble)"
      ]
      [
        "<cmd>Trouble qflist toggle<cr>"
        "<leader>xQ"
        "n"
        "Quickfix List (Trouble)"
      ]
    ];
  };
}
