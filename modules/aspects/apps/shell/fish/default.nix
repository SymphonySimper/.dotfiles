{ lib, ... }: {
  den.aspects.apps.shell.fish = {
    homeManager =
      { config, ... }:
      let
        shared = import ../_shared.nix { inherit config; };
      in
      {
        imports = [ ./_cd-bookmarks.nix ];

        programs.fish = {
          enable = true;
          generateCompletions = true;

          interactiveShellInit = ''
            set --global fish_greeting ""

            # prompt variables
            set --global _my_prompt_reset (set_color --reset)
            set --global _my_prompt_bold_color (set_color --bold '${shared.prompt.color.hex}')
          '';

          functions = {
            # based on `astronaut` prompt
            fish_prompt.body = ''
              echo -e "$_my_prompt_bold_color$(string replace "$HOME" '~' "$PWD") \n${shared.prompt.arrow}$_my_prompt_reset "
            '';
          };
        };
      };

    helix = { pkgs, ... }: {
      languages.language-server = {
        fish-lsp.command = lib.getExe pkgs.fish-lsp;
      };
    };
  };
}
