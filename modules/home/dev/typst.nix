{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.typst = {
    enable = lib.mkEnableOption "Typst";
  };

  config = lib.mkIf config.dev.typst.enable {
    home.packages = [ pkgs.typst ];

    programs.nixvim = {
      extraPackages = [ pkgs.typstyle ];

      lsp.servers.tinymist.enable = true;

      plugins.conform-nvim.formatters.typst = [ "typstyle" ];
      plugins.treesitter.grammars = [ "typst" ];
    };
  };
}
