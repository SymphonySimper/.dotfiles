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

    programs.neovim = {
      extraPackages = [
        pkgs.ruff
        pkgs.ty
      ];

      config = {
        conform = ''
          conform.formatters_by_ft.python = { "ruff" } 
        '';

        lsp = ''
          vim.lsp.enable("ruff") 
          vim.lsp.enable("ty") 
        '';
      };
    };
  };
}
