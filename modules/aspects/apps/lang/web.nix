{
  den.aspects.apps.lang.web = {
    nixos = {
      networking.firewall = {
        allowedTCPPorts = [
          5173 # vite
        ];
      };
    };

    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        inherit (import ./_shared.nix { inherit pkgs lib; }) mkPrettier mkVscodeLsp;

        lsp = {
          html = mkVscodeLsp "html";
          css = mkVscodeLsp "css";
          emmet = {
            name = "emmet-language-server";
            command = lib.getExe pkgs.emmet-language-server;
          };
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

          languages = {
            language = builtins.concatLists [
              [
                {
                  name = "html";
                  formatter = mkPrettier "html";
                  language-servers = [
                    lsp.html.name
                    lsp.emmet.name
                    lsp.tailwind.name
                  ];
                }
                {
                  name = "css";
                  formatter = mkPrettier "css";
                  language-servers = [
                    lsp.css.name
                    lsp.tailwind.name
                  ];
                }
                {
                  name = "svelte";
                  formatter = mkPrettier "svelte";
                  language-servers = [
                    "svelteserver"
                    lsp.emmet.name
                    lsp.tailwind.name
                  ];
                }
              ]

              (map
                (name: {
                  inherit name;
                  formatter = mkPrettier "typescript";
                  language-servers = builtins.concatLists [
                    [ lsp.ts.name ]
                    (lib.optionals (lib.strings.hasSuffix "sx" name) [
                      lsp.emmet.name
                      lsp.tailwind.name
                    ])
                  ];
                })
                [
                  "javascript"
                  "jsx"
                  "typescript"
                  "tsx"
                ]
              )
            ];

            language-server = {
              ${lsp.html.name}.command = lsp.html.command;
              ${lsp.css.name}.command = lsp.css.command;
              ${lsp.tailwind.name}.command = lsp.tailwind.command;
              ${lsp.ts.name}.command = lsp.ts.command;

              ${lsp.emmet.name} = {
                command = lsp.emmet.command;
                args = [ "--stdio" ];
              };

              ${lsp.svelte.name} = {
                command = lsp.svelte.command;
                config.configuration.svelte.plugin.svelte.defaultScriptLanguage = "ts";
              };
            };
          };
        };
      };
  };
}
