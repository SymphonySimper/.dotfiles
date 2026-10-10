{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  # refer: https://www.schemastore.org/
  mkSchema =
    name:
    if (lib.strings.hasInfix "/" name) then
      name
    else
      "${inputs.schemastore}/src/schemas/json/${name}.json";
in
{
  options.dev.json = {
    enable = lib.mkEnableOption "JSON";
  };

  config = lib.mkIf config.dev.json.enable {
    programs.nixvim = {
      extraPackages = [
        pkgs.prettier
      ];

      lsp.servers.jsonls = {
        enable = true;
        config.settings.json = {
          validate = true;
          schemas =
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
              ];
        };
      };

      plugins.conform-nvim.formatters = rec {
        json = [ "prettier" ];
        jsonc = json;
        json5 = json;
      };

      plugins.treesitter.grammars = [
        "json"
        "json5"
      ];
    };
  };
}
