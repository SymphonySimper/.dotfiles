{
  inputs,
  config,
  pkgs,
  lib,
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
in
{
  options.dev.json = {
    enable = lib.mkEnableOption "JSON";
  };

  config = lib.mkIf config.dev.json.enable {
    programs.neovim = {
      extraPackages = [
        pkgs.prettier
        pkgs.vscode-langservers-extracted
      ];
      config = {
        conform = ''
          conform.formatters_by_ft.json = { "prettier" }
          conform.formatters_by_ft.jsonc = { "prettier" }
          conform.formatters_by_ft.json5 = { "prettier" }            
        '';

        lsp =
          let
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
          in
          ''
            vim.lsp.config("jsonls", {
              settings = {
                json = {
                  validate = { enable = true },
                  schemas = ${lib.generators.toLua { } schemas}
                },
              },
            })
            vim.lsp.enable("jsonls")
          '';

        treeSitter.packages = [
          "json"
          "json5"
        ];
      };
    };
  };
}
