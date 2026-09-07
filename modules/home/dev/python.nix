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
          conform.formatters_by_ft.python = { "ruff_format" }
          conform.formatters.ruff_format = { append_args = { "--line-length", "88" } }
        '';

        treeSitter.packages = [ "python" ];

        lsp = ''
          vim.lsp.enable("ruff") 
          vim.lsp.enable("ty") 
        '';
      };
    };
  };
}
