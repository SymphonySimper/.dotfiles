{ config, lib, ... }:
{
  options.dev.toml = {
    enable = lib.mkEnableOption "TOML";
  };

  config = lib.mkIf config.dev.toml.enable {
    programs.nixvim = {
      lsp.servers.taplo.enable = true;

      plugins.conform-nvim.formatters.toml = [ "taplo" ];
      plugins.treesitter.grammars = [ "toml" ];
    };
  };
}
