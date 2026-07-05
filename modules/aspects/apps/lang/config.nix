{ inputs, ... }: {
  flake-file.inputs.schemastore = {
    url = "github:SchemaStore/schemastore";
    flake = false;
  };

  den.aspects.apps.lang.config = {
    homeManager =
      { pkgs, lib, ... }:
      let
        inherit (import ./_shared.nix { inherit pkgs lib; }) mkPrettier mkVscodeLsp;

        # refer:  https://www.schemastore.org/
        mkSchema =
          name:
          if (lib.strings.hasInfix "/" name) then
            name
          else
            "${inputs.schemastore}/src/schemas/json/${name}.json";

        lsp = {
          json = mkVscodeLsp "json";
        };
      in
      {
        programs.helix.languages = rec {
          language = builtins.concatLists [
            [
              {
                name = "yaml";
                formatter = mkPrettier "yaml";
              }
              {
                name = "toml";
                formatter = {
                  command = language-server.taplo.command;
                  args = [
                    "format"
                    "-"
                  ];
                };
              }
            ]

            (map
              (name: {
                inherit name;
                formatter = mkPrettier name;
                language-servers = [ lsp.json.name ];
              })
              [
                "json"
                "jsonc"
              ]
            )
          ];

          language-server = {
            taplo.command = lib.getExe pkgs.taplo;

            ${lsp.json.name} = {
              command = lsp.json.command;

              config.json = {
                validate.enable = true;

                schemas = (
                  map
                    (schema: {
                      fileMatch = schema.file;
                      url = mkSchema schema.name;
                    })
                    [
                      {
                        name = "package";
                        file = [ "package.json" ];
                      }
                      {
                        name = "tsconfig";
                        file = [
                          "tsconfig.json"
                          "tsconfig.*.json"
                        ];
                      }
                      {
                        name = "chrome-manifest";
                        file = [ "manifest.json" ];
                      }
                    ]
                );
              };
            };
          };
        };
      };
  };
}
