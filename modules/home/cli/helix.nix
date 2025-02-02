{
  my,
  inputs,
  config,
  lib,
  ...
}:
{
  options.programs.helix = {
    grammars = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Treesitter grammars to install";
      default = [ ];
    };

    lsp = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Alias for languages.langauge-server";
      default = { };
    };

    language = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
      description = "Alias for languages.langauge";
      default = [ ];
    };
  };

  config.programs.helix = {
    enable = true;
    package = inputs.helix.packages.${my.system}.default;
    defaultEditor = false;

    settings = {
      editor = {
        line-number = "relative";
        auto-format = false;
        bufferline = "never";
        auto-pairs = true;
        true-color = my.profile == "wsl";

        cursor-shape = rec {
          normal = "block";
          insert = "bar";
          select = normal;
        };

        lsp = {
          enable = true;
          display-inlay-hints = false;
        };
      };

      keys.normal.space.c = {
        c = "toggle_comments";
        f = ":format";
      };
    };

    languages = {
      use-grammars.only = config.programs.helix.grammars;
      language-server = config.programs.helix.lsp;
      language = config.programs.helix.language;
    };
  };
}
