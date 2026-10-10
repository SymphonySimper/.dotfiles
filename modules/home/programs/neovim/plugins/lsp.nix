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
          _G.complete_path = function(findstart, base)
            if findstart == 1 then
              local line = vim.api.nvim_get_current_line()
              local cursor = vim.api.nvim_win_get_cursor(0)[2]

              return vim.fn.match(line:sub(1, cursor), [[\f*$]])
            end

            return {
              words = base == "" and {} or vim.fn.getcompletion(base, "file", true),
              refresh = "always",
            }
          end

          vim.opt.autocomplete = true
          vim.opt.completefunc = "v:lua.complete_path"
          vim.opt.complete:append("F")
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
