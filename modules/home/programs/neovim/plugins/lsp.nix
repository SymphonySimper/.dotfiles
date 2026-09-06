{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.neovim.lsp = lib.mkOption {
    type = lib.types.lines;
    description = "LSP config";
    default = "";
  };

  config = {
    programs.neovim.plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = config.programs.neovim.lsp; # refer: https://github.com/neovim/nvim-lspconfig#quickstart
      }
    ];
  };
}
