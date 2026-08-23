{ config, lib, ... }:
let
  cfg = config.programs.helix;
in
{
  options.programs.helix = {
    lang = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          freeformType = lib.types.attrsOf lib.types.anything;

          options.language-servers = lib.mkOption {
            type = lib.types.listOf lib.types.anything;
            default = [ ];
          };
        }
      );
      description = "languages.language with merge";
      default = { };
    };

    lsp = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "languages.language-server alias";
      default = { };
    };

    schema = (
      lib.genAttrs [ "json" ] (
        lang:
        lib.mkOption {
          description = "Schema for completion support from LSP";

          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Name / URL of Schema";
                };

                file = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = "File patterns";
                };
              };
            }
          );

          default = [ ];
        }
      )
    );
  };

  config = {
    programs.helix.languages = {
      language-server = cfg.lsp;
      language = lib.mapAttrsToList (name: value: { inherit name; } // value) cfg.lang;
    };
  };
}
