{
  config,
  lib,
  mkPrettier,
  ...
}:
{
  options.dev.yaml = {
    enable = lib.mkEnableOption "YAML";
  };

  config = lib.mkIf config.dev.yaml.enable {
    programs.helix = {
      lang.yaml.formatter = mkPrettier "yaml";
    };
  };
}
