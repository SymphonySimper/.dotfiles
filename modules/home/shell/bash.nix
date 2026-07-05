{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.shell.bash;
  shared = import ./_shared.nix { inherit config; };
in
{
  options.my.programs.shell = {
    bash.enable = lib.mkEnableOption "Enable bash shell";
  };

  config = lib.mkIf cfg.enable {
    my.programs = {
      editor.lsp.bash-language-server.command = lib.getExe (
        pkgs.bash-language-server.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/bash-language-server \
              --suffix PATH : ${pkgs.lib.makeBinPath [ pkgs.shfmt ]}
          '';
        })
      );
    };

    programs = {
      bash = {
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

      readline = {
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
    };
  };
}
