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
    programs.helix = rec {
      lsp.taplo.command = lib.getExe pkgs.taplo;

      lang.toml.formatter = {
        command = lsp.taplo.command;
        args = [
          "format"
          "-"
        ];
      };
    };
  };
}
