{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.web = {
    enable = lib.mkEnableOption "Web";
  };

  config = lib.mkIf config.dev.web.enable {

    home.packages = [
      pkgs.nodejs_24
      pkgs.corepack_24 # switch to corepack for nodejs >= 25
    ];

    home.sessionVariables = {
      PNPM_HOME = "${config.xdg.dataHome}/pnpm";
    };

    home.sessionPath = [
      config.home.sessionVariables.PNPM_HOME
    ];

    programs.neovim = {
      extraPackages = [
        pkgs.prettier

        pkgs.svelte-language-server
        pkgs.tailwindcss-language-server
        pkgs.typescript-language-server
        pkgs.vscode-langservers-extracted
      ];

      config = {
        conform = ''
          local web_langs = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" }

          for _, lang in pairs(web_langs) do
            conform.formatters_by_ft[lang] = { "prettier" }   
          end
        '';

        lsp = ''
          local web_lsps = { "html", "cssls", "ts_ls", "tailwindcss", "svelte" }
            
          for _, lsp in pairs(web_lsps) do
            vim.lsp.enable(lsp)   
          end
        '';
      };
    };
  };
}
