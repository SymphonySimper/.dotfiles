{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.neovim.config.lsp = lib.mkOption {
    type = lib.types.lines;
    description = "LSP config";
    default = "";
  };

  config = {
    programs.neovim.plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = ''
          vim.opt.completeopt:append({ "fuzzy", "menuone", "noselect", "popup" })

          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

              if client:supports_method("textDocument/completion") then
                vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
              end
            end,
          })

          ${config.programs.neovim.config.lsp}
        ''; # refer: https://github.com/neovim/nvim-lspconfig#quickstart
      }
    ];
  };
}
