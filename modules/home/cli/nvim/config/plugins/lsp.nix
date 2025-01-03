{ lib, ... }:
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = false;
    keymaps = {
      silent = true;

      lspBuf = {
        gd = "definition";
        gr = "references";
        gt = "type_definition";
        gi = "implementation";
        K = "hover";
        "<leader>cr" = "rename";
        "<leader>ca" = "code_action";
      };

      extra = lib.my.mkKeymaps [
        [
          ":LspRestart<Enter>"
          "<leader>lr"
          "n"
          "Restart LSP"
        ]
        [
          { __raw = "vim.lsp.buf.signature_help"; }
          "gK"
          "n"
          "Signature Help"
        ]
        [
          { __raw = "vim.lsp.buf.signature_help"; }
          "<c-k>"
          "i"
          "Signature Help"
        ]
        [
          { __raw = "vim.diagnostic.open_float"; }
          "<leader>cd"
          "n"
          "Line Diagnostics"
        ]
      ];
    };
  };
}
