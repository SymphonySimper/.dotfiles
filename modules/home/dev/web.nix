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
      pkgs.bun
      pkgs.corepack_24 # switch to corepack for nodejs >= 25
      pkgs.nodejs_24
    ];

    home.sessionVariables = {
      PNPM_HOME = "${config.xdg.dataHome}/pnpm";
    };

    home.sessionPath = [
      config.home.sessionVariables.PNPM_HOME
    ];

    programs.nixvim = {
      extraPackages = [ pkgs.prettier ];

      lsp.servers = lib.genAttrs [ "html" "cssls" "ts_ls" "tailwindcss" "svelte" ] (_: {
        enable = true;
      });

      plugins.conform-nvim.formatters = lib.genAttrs [
        "html"
        "css"
        "javascript"
        "typescript"
        "javascriptreact"
        "typescriptreact"
        "svelte"
      ] (_: [ "prettier" ]);

      plugins.treesitter.grammars = [
        "html"
        "css"
        "javascript"
        "typescript"
        "tsx"
        "svelte"
      ];
    };
  };
}
