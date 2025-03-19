{
  my,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.helix;
in
{
  options.programs.helix = {
    ignore = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Global ignore patterns for editor.file-picker";
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

  imports = [
    ./ignore.nix
    ./keymap.nix
    ./settings.nix
  ];

  config = {
    xdg.configFile."helix/ignore".text = builtins.concatStringsSep "\n" (lib.lists.unique cfg.ignore);

    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${my.system}.default;
      defaultEditor = true;

      languages = {
        language-server = cfg.lsp;
        language = cfg.language;
      };
    };
  };
}
