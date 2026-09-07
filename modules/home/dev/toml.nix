{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.toml = {
    enable = lib.mkEnableOption "TOML";
  };

  config = lib.mkIf config.dev.toml.enable {
    programs.neovim = {
      extraPackages = [ pkgs.taplo ];

      config = {
        conform = ''conform.formatters_by_ft.toml = { "taplo" }'';
        lsp = ''vim.lsp.enable("taplo")'';
      };
    };
  };
}
