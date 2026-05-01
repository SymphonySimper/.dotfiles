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
  ];

  options.my.programs.shell = {
    bash = {
      enable = lib.mkEnableOption "Enable Bash" // {
        default = true;
      };
    }
    // (lib.my.mkCommandOption {
      category = "Shell";
      command = "bash";
      args = {
        login = "--login";
        command = "-c";
        bin = "${my.dir.home}/.nix-profile/bin";
      };
    });

    addToPath = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Add a executable to ~/.local/bin";
      default = { };
    };
  };

  config = {
    my.programs = {
      editor = {
        packages = with pkgs; [
          bash-language-server
          shfmt
          shellcheck
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
        enable = true;
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

      direnv = {
        enable = true;
        nix-direnv.enable = true;

        silent = false;
        config.warn_timeout = "2m";
      };
    };
  };
}
