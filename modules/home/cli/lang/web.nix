{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      nodejs
      corepack
      # nodePackages_latest.npm
      # nodePackages_latest.pnpm
    ];

    shellAliases = {
      jp = "pnpm";
      jpi = "pnpm i";
      jprd = "pnpm run dev";
      jpf = "pnpm format";
      jn = "npm";
      jni = "npm i";
      jnrd = "npm run dev";
      jnf = "npm run format";
    };

    sessionVariables = rec {
      PNPM_HOME = "${config.xdg.dataHome}/pnpm";
      PATH = "$PATH:${PNPM_HOME}";
    };
  };

  programs.nixvim.plugins = {
    treesitter.grammars = [
      "html"
      "css"
      "scss"
      "javascript"
      "typescript"
      "svelte"

      "json"
    ];

    conform-nvim = {
      formatter.biome = pkgs.biome;
      settings.formatters_by_ft = rec {
        javascript = [ "prettier" ];
        typescript = javascript;
        svelte = javascript;
        css = javascript;
        html = javascript;

        json = [ "biome" ];
        jsonc = json;
      };
    };

    lsp.servers = {
      # Svelte
      svelte = {
        enable = true;
        initOptions.svelte.plugin.svelte.defaultScriptLanguage = "ts";
      };
      # Tailwind
      tailwindcss.enable = true;
      # Typescript
      ts_ls.enable = true;
      # HTML
      html.enable = true;
      # JSON
      jsonls.enable = true;
    };
  };
}
