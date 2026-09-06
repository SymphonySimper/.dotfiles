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
        config = config.programs.neovim.config.lsp; # refer: https://github.com/neovim/nvim-lspconfig#quickstart
      }
    ];
  };
}
