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
    programs.neovim = {
      extraPackages = [
        pkgs.prettier
        pkgs.mpls
      ];

      config = {
        conform = ''
          conform.formatters_by_ft.markdown = { "prettier" }
          conform.formatters_by_ft["markdown.mdx"] = { "prettier" }
        '';

        lsp = ''
          vim.lsp.config("mpls", {
            cmd = {
              "mpls",
              "--enable-emoji",
              "--enable-footnotes",
              "--no-auto",
              "--theme",
              "${mkGetTheme { name = "%name%-%flavor%"; }}"
            }
          })
          vim.lsp.enable("mpls") 
        '';
      };
    };
  };
}
