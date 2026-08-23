{
  config,
  pkgs,
  lib,
  ...
}:
let
  harper = rec {
    name = "harper-ls";
    command = lib.getExe' pkgs.harper name;
  };
in
{
  options.dev.harper = {
    enable = lib.mkEnableOption "Harper";
  };

  config = lib.mkIf config.dev.harper.enable {
    programs.helix = {
      lsp.${harper.name}.command = harper.command;

      lang =
        lib.genAttrs
          [
            "git-commit"
            "markdown"
          ]
          (name: {
            language-servers = [ harper.name ];
          });
    };
  };
}
