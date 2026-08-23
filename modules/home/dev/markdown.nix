{
  config,
  pkgs,
  lib,
  mkGetTheme,
  mkPrettier,
  ...
}:
let
  mpls = {
    name = "mpls";
    command = lib.getExe pkgs.mpls;
  };
in
{
  options.dev.markdown = {
    enable = lib.mkEnableOption "Markdown";
  };

  config = lib.mkIf config.dev.markdown.enable {
    programs.helix = {
      lang.markdown = {
        # refer: https://github.com/helix-editor/helix/wiki/Recipes#continue-markdown-lists--quotes
        comment-tokens = [
          "-"
          "+"
          "*"
          "- [ ]"
          ">"
        ];
        formatter = mkPrettier "markdown";
        language-servers = [ mpls.name ];
      };

      lsp.${mpls.name} = {
        command = mpls.command;
        args = [
          "--no-auto"
          "--enable-emoji"
          "--theme"
          (mkGetTheme { name = "%name%-%flavor%"; })
        ];
      };
    };
  };
}
