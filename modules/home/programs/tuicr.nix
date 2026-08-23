{
  config,
  pkgs,
  lib,
  mkGetTheme,
  ...
}:
{
  options.programs.tuicr = {
    enable = lib.mkEnableOption "tuicr";
  };

  config = lib.mkIf config.programs.tuicr.enable {
    home.packages = [ pkgs.tuicr ];

    xdg.configFile."tuicr/config.toml".source = (pkgs.formats.toml { }).generate "tuicr-config.toml" {
      theme = mkGetTheme { name = "%name%-%flavor%"; };

      diff_view = "side-by-side";
      single_file_view = true;
      relative_line_numbers = true;
      comment_vim = true;

      # binary is managed by nix
      no_update_check = true;
    };
  };
}
