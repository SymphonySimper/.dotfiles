{
  config,
  pkgs,
  lib,
  mkGetTheme,
  ...
}:
{
  options.dev.markdown = {
    enable = lib.mkEnableOption "Markdown";
  };

  config = lib.mkIf config.dev.markdown.enable {
    programs.nixvim = {
      extraPackages = [
        pkgs.prettier
      ];

      lsp.servers.mpls = {
        enable = true;
        config.cmd = [
          "mpls"
          "--enable-emoji"
          "--enable-footnotes"
          "--no-auto"
          "--theme"
          (mkGetTheme { name = "%name%-%flavor%"; })
        ];
      };

      plugins.conform-nvim.formatters = rec {
        markdown = [ "prettier" ];
        "markdown.mdx" = markdown;
      };
    };
  };
}
