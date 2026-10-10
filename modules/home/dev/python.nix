{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.python = {
    enable = lib.mkEnableOption "Python";
  };

  config = lib.mkIf config.dev.python.enable {
    home.packages = [ pkgs.python3 ];

    programs.uv = {
      enable = true;
      settings = {
        python-downloads = "automatic";
      };
    };

    programs.nixvim = {
      lsp.servers = {
        ruff.enable = true;
        ty.enable = true;
      };

      plugins.conform-nvim.formatters.python = [ "ruff_format" ];
      plugins.treesitter.grammars = [ "python" ];
    };
  };
}
