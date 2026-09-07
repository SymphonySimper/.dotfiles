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

      config = {
        treeSitter.packages = [ "yaml" ];
        conform = ''conform.formatters_by_ft.yaml = { "prettier" }'';
      };
    };
  };
}
