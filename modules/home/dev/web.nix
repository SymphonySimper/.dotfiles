{
  config,
  pkgs,
  lib,
  mkVscodeLsp,
  mkPrettier,
  ...
}:
let
  lsp = {
    html = mkVscodeLsp "html";
    css = mkVscodeLsp "css";
    tailwind = {
      name = "tailwindcss-ls";
      command = lib.getExe pkgs.tailwindcss-language-server;
    };
    ts = {
      name = "typescript-language-server";
      command = lib.getExe pkgs.typescript-language-server;
    };
    svelte = {
      name = "svelteserver";
      command = lib.getExe pkgs.svelte-language-server;
    };
  };
in
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

    programs.helix = {
      ignores = [
        "node_modules"
        "vite.config.js.timestamp-*"
        "vite.config.ts.timestamp-*"

        "!*prettier*"
        "!.npmrc"
        ".svelte-kit"
      ];

      lang = {
        html = {
          formatter = mkPrettier "html";
          language-servers = [
            lsp.html.name
            lsp.tailwind.name
          ];
        };
        css = {
          formatter = mkPrettier "css";
          language-servers = [
            lsp.css.name
            lsp.tailwind.name
          ];
        };
        svelte = {
          formatter = mkPrettier "svelte";
          language-servers = [
            "svelteserver"
            lsp.tailwind.name
          ];
        };
      }
      // (lib.genAttrs
        [
          "javascript"
          "jsx"
          "typescript"
          "tsx"
        ]
        (name: {
          formatter = mkPrettier "typescript";
          language-servers = builtins.concatLists [
            [ lsp.ts.name ]
            (lib.optionals (lib.strings.hasSuffix "sx" name) [
              lsp.tailwind.name
            ])
          ];
        })
      );

      lsp = {
        ${lsp.html.name}.command = lsp.html.command;
        ${lsp.css.name}.command = lsp.css.command;
        ${lsp.tailwind.name}.command = lsp.tailwind.command;
        ${lsp.ts.name}.command = lsp.ts.command;

        ${lsp.svelte.name} = {
          command = lsp.svelte.command;
          config.configuration.svelte.plugin.svelte.defaultScriptLanguage = "ts";
        };
      };
    };
  };
}
