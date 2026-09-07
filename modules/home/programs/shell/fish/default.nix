{
  config,
  pkgs,
  lib,
  ...
}:
let
  shared = import ../_shared.nix { inherit config; };
in
{
  imports = [ ./cd-bookmarks.nix ];

  programs.fish = {
    enable = lib.mkDefault true;
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

  programs.neovim = {
    extraPackages = [ pkgs.fish-lsp ];

    config = {
      treeSitter.packages = [ "fish" ];
      conform = ''conform.formatters_by_ft.fish = { "fish_indent" }'';
      lsp = ''vim.lsp.enable("fish_lsp")'';
    };
  };
}
