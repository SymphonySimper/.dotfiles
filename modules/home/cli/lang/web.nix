{ pkgs, config, ... }:
{
  my = {
    home = {
      packages = with pkgs; [
        nodejs
        corepack
        # nodePackages_latest.npm
        # nodePackages_latest.pnpm
      ];

      shell = {
        aliases = {
          jp = "pnpm";
          jpi = "pnpm i";
          jprd = "pnpm run dev";
          jpf = "pnpm format";
          jn = "npm";
          jni = "npm i";
          jnrd = "npm run dev";
          jnf = "npm run format";
        };

        env = rec {
          PNPM_HOME = "${config.xdg.dataHome}/pnpm";
          PATH = "$PATH:${PNPM_HOME}";
        };
      };
    };

    programs.nvim = {
      treesitter = [
        "html"

        "css"
        "scss"

        "javascript"
        "typescript"
        "svelte"
      ];

      lsp = {
        svelte = {
          enable = true;
          initOptions.svelte.plugin.svelte.defaultScriptLanguage = "ts";
        };
        tailwindcss.enable = true;
        # Typescript
        ts_ls.enable = true;
        html.enable = true;
      };

      formatter = {
        packages = [
          pkgs.nodePackages.prettier
        ];
        ft = rec {
          javascript = "prettier";
          typescript = javascript;
          svelte = javascript;
          css = javascript;
          html = javascript;
        };
      };
    };
  };
}
