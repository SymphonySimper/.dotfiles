{ config, lib, ... }:
let
  cfg = config.programs.nixvim.plugins.conform-nvim;
in
{
  options.programs.nixvim.plugins.conform-nvim = {
    formatters = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      description = "Alias to `conform-nvim.settings.formatters_by_ft`";
      default = { };
    };
  };

  config = {
    programs.nixvim = {
      plugins.conform-nvim = {
        enable = true;
        settings.formatters_by_ft = cfg.formatters;
      };

      keymaps = [
        {
          action.__raw = "require(\"conform\").format";
          key = "<leader>cf";
          mode = [ "n" ];

          options = {
            silent = true;
            desc = "Format file";
          };
        }
      ];
    };
  };
}
