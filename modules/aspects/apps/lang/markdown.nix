{
  den.aspects.apps.lang.markdown = {
    homeManager =
      {
        mkGetTheme,
        pkgs,
        lib,
        ...
      }:
      let
        inherit (import ./_shared.nix { inherit pkgs lib; }) mkPrettier;

        mpls = {
          name = "mpls";
          command = lib.getExe pkgs.mpls;
        };
      in
      {
        programs.helix = {
          lang = {
            markdown = {
              # refer: https://github.com/helix-editor/helix/wiki/Recipes#continue-markdown-lists--quotes
              comment-tokens = [
                "-"
                "+"
                "*"
                "- [ ]"
                ">"
              ];
              formatter = mkPrettier "markdown";
              language-servers = [ mpls.name ];
            };
          };

          lsp.${mpls.name} = {
            command = mpls.command;
            args = [
              "--no-auto"
              "--enable-emoji"
              "--theme"
              (mkGetTheme { name = "%name%-%flavor%"; })
            ];
          };
        };
      };
  };
}
