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

    # (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "root" ] [ "programs" "bash" ])
  ];

  options.my.programs.shell = {
    nativePrompt = lib.mkEnableOption "Use native prompt instead of starship";

    nu = lib.my.mkCommandOption {
      category = "Interactive Shell";
      command = "nu";
      args = {
        command = "--commands";
      };
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

      shell.env = {
        LS_COLORS = ""; # Some programs misbehave when this is not set.
        STARSHIP_LOG = "error";
      };
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
              rgb = my.theme.color.lavender.rgb;
              boldColor = "\\e[38;2;${rgb.r};${rgb.g};${rgb.b};1m";
              reset = "\\e[0m";
            in
            lib.optionalString cfg.nativePrompt ''
              PS1='\[${boldColor}\]\w\n> \[${reset}\]'
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

      nushell = {
        enable = true;

        settings = {
          show_banner = false;

          buffer_editor = "${config.my.programs.editor.command}";

          history.file_format = "sqlite";
          history.isolation = true;

          completions.algorithm = "fuzzy";
          completions.external.max_results = 20;

          datetime_format.normal = "%d/%m/%y %I:%M:%S%p";

          filesize.unit = "metric";
          filesize.show_unit = true;
        };
      };

      carapace.enable = true;
      zoxide.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;

        silent = !cfg.nativePrompt;
        config.warn_timeout = "2m";
      };

      starship = {
        enable = !cfg.nativePrompt;

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

          direnv.disabled = false;
          gcloud.disabled = true;
        };
      };
    };
  };
}
