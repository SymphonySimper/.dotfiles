{
  config,
  pkgs,
  lib,
  ...
}:
let
  shared = import ./_shared.nix { inherit config; };
in
{
  imports = [
    ./fish

    ./interactive.nix
    ./nushell.nix
  ];

  home.sessionVariables = {
    LS_COLORS = ""; # Some programs misbehave when this is not set.
  };

  home.sessionPath = [ "${config.xdg.dataHome}/../bin" ];

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellOptions = [
      "autocd" # cd when directory
    ];

    initExtra = lib.strings.concatLines [
      (
        let
          boldColor = "\\e[38;2;${shared.prompt.color.rgb.r};${shared.prompt.color.rgb.g};${shared.prompt.color.rgb.b};1m";
          reset = "\\e[0m";
        in
        ''
          PS1='\[${boldColor}\]\w\n${shared.prompt.arrow} \[${reset}\]'
        ''
      )
    ];
  };

  programs.readline = {
    enable = true;

    variables = {
      completion-ignore-case = true;
      show-all-if-ambiguous = true;
    };

    bindings = {
      "\\C-l" = "clear-screen";
      "\\e[Z" = "menu-complete"; # Shift+Tab to cycle through complete options
      "\\ee" = "edit-and-execute-command"; # open and edit command in $EDITOR
    };
  };

  programs.neovim = {
    extraPackages = [
      pkgs.shfmt
      pkgs.bash-language-server
    ];

    config = {
      treeSitter.packages = [ "bash" ];
      conform = ''conform.formatters_by_ft.sh = { "shfmt" }'';
      lsp = ''vim.lsp.enable("bashls")'';
    };
  };
}
