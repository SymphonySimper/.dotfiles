{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.neovim.config.treeSitter;
in
{
  options.programs.neovim.config.treeSitter = {
    packages = lib.mkOption {
      type = lib.types.listOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.package
        ]
      );
      description = "Tree-sitters to be added to runtime";
      default = [ ];
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      description = "Tree-sitter related config";
      default = "";
    };
  };

  config = {
    programs.neovim.plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (
          parsers:
          (lib.lists.unique (
            map (
              package: if builtins.typeOf package == "string" then parsers.${package} else package
            ) cfg.packages
          ))
        );

        config = cfg.extraConfig;
      }
    ];
  };
}
