{
  config,
  pkgs,
  lib,
  ...
}:
{
  # NOTE: programs.just is marked as removed by home-manager. So it cannot be used.
  options.programs.justfile = {
    enable = lib.mkEnableOption "Just" // {
      default = true;
    };
  };

  config = lib.mkIf config.programs.justfile.enable {
    home.packages = [ pkgs.just ];

    programs.neovim.config = {
      conform = ''conform.formatters_by_ft.just = { "just" }'';
      treeSitter.packages = [ "just" ];
    };
  };
}
