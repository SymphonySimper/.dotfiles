{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.shell;

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
              boldColor = "\\e[38;2;${prompt.color.rgb.r};${prompt.color.rgb.g};${prompt.color.rgb.b};1m";
              reset = "\\e[0m";
            in
            lib.optionalString cfg.nativePrompt ''
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

      nushell = {
        enable = true;

        extraConfig = ''
          $env.config.show_banner = false;

          $env.config.buffer_editor = "${config.my.programs.editor.command}";

          $env.config.history.file_format = "sqlite";
          $env.config.history.isolation = true;

          $env.config.completions.algorithm = "fuzzy";
          $env.config.completions.external.max_results = 20;

          $env.config.datetime_format.normal = "%d/%m/%y %I:%M:%S%p";

          $env.config.filesize.unit = "metric";
          $env.config.filesize.show_unit = true;
        '';

        extraEnv = lib.strings.concatLines [
          (
            # refer: https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/default_files/default_env.nu
            let
              color = "ansi --escape { fg: '${prompt.color.hex}', attr: b }";
            in
            lib.strings.optionalString cfg.nativePrompt ''
              $env.PROMPT_COMMAND = {||
                  let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
                      null => $env.PWD
                      ${"''"} => '~'
                      $relative_pwd => ([~ $relative_pwd] | path join)
                  }

                  let path_color = (if (is-admin) { ansi red_bold } else { ${color} })
                  let separator_color = (if (is-admin) { ansi light_red_bold } else { ${color} })
                  let path_segment = $"($path_color)($dir)(ansi reset)\n"

                  $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
              }

              $env.PROMPT_INDICATOR = $"(${color})${prompt.arrow}(ansi reset) "

              $env.PROMPT_COMMAND_RIGHT = ""
            ''
          )
        ];
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
          scan_timeout = 5; # default 30
          command_timeout = 10; # default 500
          format = lib.concatStrings [
            "$all"
            # "$fill"
            "$time"
            "$line_break"
            "$character"
          ];

          character = {
            success_symbol = "[${prompt.arrow}](bold lavender)";
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
