{
  den.aspects.apps.lang.english = {
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      let
        harper = rec {
          name = "harper-ls";
          command = lib.getExe' pkgs.harper name;
        };
      in
      {
        programs.helix = {
          lsp = {
            ${harper.name}.command = harper.command;
          };

          lang =
            lib.genAttrs
              [
                "git-commit"
                "markdown"
              ]
              (name: {
                language-servers = [ harper.name ];
              });
        };
      };
  };
}
