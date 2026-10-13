{ config, lib, ... }:
let
  cfg = config.programs.nixvim.plugins.treesitter;
in
{
  options.programs.nixvim.plugins.treesitter = {
    grammars = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Tree-sitters to be added to runtime";
      default = [ ];
    };
  };

  config = {
    programs.nixvim.plugins.treesitter = {
      enable = true;

      highlight = {
        enable = true;
        disable.__raw = ''
          function(_, buf)
            local max_file_size = 100 * 1024 -- 100 KiB
            local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stat and stat.size > max_file_size or false
          end
        '';
      };

      indent.enable = false;
      folding.enable = false;

      nixvimInjections = false;

      grammarPackages = lib.lists.unique (
        map (grammar: cfg.package.builtGrammars.${grammar}) cfg.grammars
      );
    };
  };
}
