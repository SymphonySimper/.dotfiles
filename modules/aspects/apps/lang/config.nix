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

        json = mkVscodeLsp "json";
      in
      {
        programs.helix = rec {
          lang = {
            yaml.formatter = mkPrettier "yaml";
            toml.formatter = {
              command = lsp.taplo.command;
              args = [
                "format"
                "-"
              ];
            };
          }
          // (lib.genAttrs
            [
              "json"
              "jsonc"
            ]
            (name: {
              formatter = mkPrettier name;
              language-servers = [ json.name ];
            })
          );

          lsp = {
            taplo.command = lib.getExe pkgs.taplo;

            ${json.name} = {
              command = json.command;

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
