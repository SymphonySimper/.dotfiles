{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.shell;
in
{
  imports = [
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "env" ] [ "home" "sessionVariables" ])
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "path" ] [ "home" "sessionPath" ])

    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "root" ] [ "programs" "bash" ])
  ];

  options.my.programs.shell =
    (lib.my.mkCommandOption {
      category = "Shell";
      command = "bash";
      args = {
        login = "--login";
        command = "-c";
        bin = "${my.dir.home}/.nix-profile/bin";
      };
    })
    // {
      addToPath = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "Add a executable to ~/.local/bin";
        default = { };
      };
    };

  config = lib.mkMerge [
    {
      home.shellAliases = {
        q = "exit";
      };

      my.programs.shell = {
        env = {
          LS_COLORS = ""; # Some programs misbehave when this is not set.
        };
      };
    }

    (
      let
        path = "../bin"; # relative to XDG_DATA_HOME
      in
      {
        my.programs.shell.path = [ "${config.xdg.dataHome}/${path}" ];

        xdg.dataFile = builtins.listToAttrs (
          builtins.map (file: {
            name = "${path}/${file.name}";
            value = {
              source = config.lib.file.mkOutOfStoreSymlink file.value;
            };
          }) (lib.attrsets.attrsToList cfg.addToPath)
        );
      }
    )

    {
      programs = {
        bash = {
          enable = true;
          enableCompletion = true;

          shellOptions = [
            "autocd" # cd when directory
          ];

          initExtra =
            let
              rgb = my.theme.color.lavender.rgb;
              boldColor = "\\e[38;2;${rgb.r};${rgb.g};${rgb.b};1m";
              reset = "\\e[0m";
            in
            ''
              PS1='\[${boldColor}\]\w\n> \[${reset}\]'
            '';
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

      my.programs.editor = {
        packages = with pkgs; [
          bash-language-server
          shfmt
          shellcheck
        ];
      };
    }

    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;

        silent = false;
        config.warn_timeout = "2m";
      };

      my.programs = {
        editor.ignore = [
          "!.envrc"
          ".direnv"
        ];
      };
    }

    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = false;
      };

      my.programs.shell = {
        root.initExtra = lib.mkOrder 4000 ''eval "$(zoxide init bash)"'';
      };
    }
  ];
}
