{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.neovim.config.conform = lib.mkOption {
    type = lib.types.lines;
    description = "Config related to conform";
    default = "";
  };

  config = {
    programs.neovim.plugins = [
      {
        plugin = pkgs.vimPlugins.conform-nvim;
        type = "lua";
        config = ''
          local conform = require("conform")
          conform.setup()

          vim.keymap.set("n", "<leader>cf", conform.format, { silent = true, desc = "Format file" })

          ${config.programs.neovim.config.conform}
        '';
      }
    ];
  };
}
