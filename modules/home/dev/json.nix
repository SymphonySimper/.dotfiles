{
  inputs,
  config,
  lib,
  mkPrettier,
  mkVscodeLsp,
  ...
}:
let
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
  options.dev.json = {
    enable = lib.mkEnableOption "JSON";
  };

  config = lib.mkIf config.dev.json.enable {
    programs.helix = {
      lang =
        lib.genAttrs
          [
            "json"
            "jsonc"
          ]
          (name: {
            formatter = mkPrettier name;
            language-servers = [ json.name ];
          });

      lsp.${json.name} = {
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
}
