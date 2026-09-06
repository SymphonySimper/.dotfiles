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

          ${config.programs.neovim.config.conform}
        '';
      }
    ];
  };
}
