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
    programs.neovim = {
      extraPackages = [ pkgs.prettier ];
      config.conform = ''conform.formatters_by_ft.yaml = { "prettier" }'';
    };
  };
}
