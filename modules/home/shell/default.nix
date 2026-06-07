{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.shell;

  binPath = rec {
    relative = "../bin"; # relative to XDG_DATA_HOME
    absolute = "${config.xdg.dataHome}/${relative}";
  };

  prompt = {
    arrow = ">";
    color = my.theme.color.lavender;
  };
in
{
  imports = [
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "env" ] [ "home" "sessionVariables" ])
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "path" ] [ "home" "sessionPath" ])

    # (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "root" ] [ "programs" "bash" ])
    (lib.modules.mkAliasOptionModule
      [ "my" "programs" "shell" "fish" "functions" ]
      [ "programs" "fish" "functions" ]
    )
    (lib.modules.mkAliasOptionModule
      [ "my" "programs" "shell" "fish" "interactiveShellInit" ]
      [ "programs" "fish" "interactiveShellInit" ]
    )

    ./cd-bookmarks.nix
  ];

  options.my.programs.shell = {
    bash = {
      enable = lib.mkEnableOption "Enable Bash";
    }
    // (lib.my.mkCommandOption {
      category = "Shell";
      command = "bash";
      args = {
        login = "--login";
        command = "-c";
      };
    });

    fish = lib.my.mkCommandOption {
      category = "Interactive Shell";
      command = "fish";
      args = {
        command = "--command";
        login = "--login";
      };
    };

    addToPath = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Add a executable to ~/.local/bin";
      default = { };
    };

    direnv.enable = lib.mkEnableOption "Enable direnv";
  };

  config = {
    my.programs = {
      editor = {
        packages = with pkgs; [
          bash-language-server
          shfmt
          shellcheck
          fish-lsp
        ];

        ignore = [
          # direnv
          "!.envrc"
          ".direnv"
        ];
      };

      shell = {
        env = {
          LS_COLORS = ""; # Some programs misbehave when this is not set.
          STARSHIP_LOG = "error";
        };

        path = [ binPath.absolute ];
      };
    };

    xdg.dataFile = builtins.listToAttrs (
      map (file: {
        name = "${binPath.relative}/${file.name}";
        value = {
          source = config.lib.file.mkOutOfStoreSymlink file.value;
        };
      }) (lib.attrsets.attrsToList cfg.addToPath)
    );

    programs = {
      bash = {
        enable = lib.mkForce cfg.bash.enable;
        enableCompletion = true;

        shellOptions = [
          "autocd" # cd when directory
        ];

        initExtra = lib.strings.concatLines [
          (
            let
              boldColor = "\\e[38;2;${prompt.color.rgb.r};${prompt.color.rgb.g};${prompt.color.rgb.b};1m";
              reset = "\\e[0m";
            in
            ''
              PS1='\[${boldColor}\]\w\n${prompt.arrow} \[${reset}\]'
            ''
          )
        ];
      };

      readline = {
        enable = lib.mkForce cfg.bash.enable;

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

      fish = {
        enable = true;
        generateCompletions = true;

        interactiveShellInit = ''
          set --global fish_greeting ""

          # prompt variables
          set --global _my_prompt_reset (set_color --reset)
          set --global _my_prompt_bold_color (set_color --bold '${prompt.color.hex}')
        '';

        functions = {
          # based on `astronaut` prompt
          fish_prompt.body = ''
            echo -e "$_my_prompt_bold_color$(string replace "$HOME" '~' "$PWD") \n${prompt.arrow}$_my_prompt_reset "
          '';

          _windows_terminal_wsl_path = lib.mkIf (my.profile == "wsl") {
            onVariable = "PWD";
            body = ''
              if test -n "$WT_SESSION"
                printf "\e]9;9;%s\e\\" (string replace --all '/' '\\' "\\\\wsl.localhost\\$WSL_DISTRO_NAME$PWD")
              end
            '';
          };
        };
      };

      direnv = {
        enable = lib.mkForce cfg.direnv.enable;
        nix-direnv.enable = true;

        silent = false;
        config.warn_timeout = "2m";
      };
    };
  };
}
