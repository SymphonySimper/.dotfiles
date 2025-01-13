{ config, lib, ... }:
{
  options.my.programs.nvim.lsp = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    description = "Nixvim LSP servers";
    default = { };
  };

  config.programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = false;
    servers = config.my.programs.nvim.lsp;
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

      extra = [
        {
          action = ":LspRestart<Enter>";
          key = "<leader>lr";
          mode = "n";
          options.desc = "Restart LSP";
        }
        {
          action.__raw = "vim.lsp.buf.signature_help";
          key = "gK";
          mode = "n";
          options.desc = "Signature Help";
        }
        {
          action.__raw = "vim.lsp.buf.signature_help";
          key = "<c-k>";
          mode = "i";
          options.desc = "Signature Help";
        }
        {
          action.__raw = "vim.diagnostic.open_float";
          key = "<leader>cd";
          mode = "n";
          options.desc = "Line Diagnostics";
        }
      ];
    };
  };
}
