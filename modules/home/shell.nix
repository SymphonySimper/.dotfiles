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

    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "prompt" ] [ "programs" "starship" ])
  ];

  options.my.programs.shell = (
    lib.my.mkCommandOption {
      category = "Shell";
      command = "bash";
      args = {
        login = "--login";
        command = "--command";
        bin = "${my.dir.home}/.nix-profile/bin";
      };
    }
    // {
      addToPath = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "Add a executable to ~/.local/bin";
        default = { };
      };
    }
  );

  config = lib.mkMerge [
    {
      home.shellAliases = rec {
        # general
        q = "exit";
        ## ls
        ls = "ls --almost-all --color=yes --group-directories-first --human-readable";
        lsl = "${ls} -l --size";
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

          # profileExtra = # sh
          #   ''
          #     # nix_loc="$HOME"/.nix-profile/etc/profile.d/nix.sh
          #     # [ -f $nix_loc ] && . $nix_loc

          #     . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          #   '';
        };

        readline = {
          enable = true;

          variables = {
            editing-mode = "vi";
            completion-ignore-case = true;
            show-all-if-ambiguous = true;
          };

          bindings = {
            "\\C-l" = "clear-screen";
            "\\e[Z" = "menu-complete"; # Shift+Tab to cycle through complete options
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

        silent = true;
        config.warn_timeout = "2m";
      };

      my.programs = {
        editor.ignore = [
          "!.envrc"
          ".direnv"
        ];

        shell.prompt.settings.direnv.disabled = false;
      };
    }

    {
      programs = {
        zoxide = {
          enable = true;
          enableBashIntegration = false;
        };

        bash.initExtra =
          lib.mkOrder 2000 # sh
            ''
              eval "$(zoxide init bash)"    
            '';
      };
    }

    {
      my.programs.shell.env.STARSHIP_LOG = "error";

      programs.starship = {
        enable = true;

        settings = {
          add_newline = false;
          scan_timeout = 30;
          command_timeout = 30; # default 500
          format = lib.concatStrings [
            "$all"
            # "$fill"
            "$time"
            "$line_break"
            "$character"
          ];

          character = {
            success_symbol = "[>](bold lavender)";
            error_symbol = "[x](bold red)";
            vimcmd_symbol = "[v](bold peach)";
          };

          fill = {
            disabled = false;
            symbol = " ";
          };

          directory = {
            style = "bold lavender";
            truncate_to_repo = false;
          };

          time = {
            disabled = false;
            format = "[($time)](overlay0)";
            time_format = "(%H:%M)";
            utc_time_offset = "local";
          };

          python.symbol = "󰌠 ";

          nix_shell = {
            format = "via [$symbol$state]($style) ";
            symbol = "󱄅 ";
          };

          gcloud.disabled = true;
        };
      };
    }

    {
      programs.vivid = {
        enable = true;
      };
    }
  ];
}
