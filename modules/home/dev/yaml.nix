{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.yaml = {
    enable = lib.mkEnableOption "YAML";
  };

  config = lib.mkIf config.dev.yaml.enable {
    programs.nixvim = {
      extraPackages = [ pkgs.prettier ];
      plugins.conform-nvim.formatters.yaml = [ "prettier" ];
      plugins.treesitter.grammars = [ "yaml" ];
    };
  };
}
