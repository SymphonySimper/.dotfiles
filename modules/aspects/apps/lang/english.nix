{
  den.aspects.apps.lang.english = {
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      let
        lsp = {
          harper = rec {
            name = "harper-ls";
            command = lib.getExe' pkgs.harper name;
          };
        };
      in
      {
        programs.helix.languages = {
          language-server = {
            ${lsp.harper.name}.command = lsp.harper.command;
          };

          language =
            map
              (name: {
                inherit name;
                language-servers = [ lsp.harper.name ];
              })
              [
                "git-commit"
                "markdown"
              ];
        };
      };
  };
}
