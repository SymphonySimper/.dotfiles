{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkReadOnlyStrOption =
    value:
    lib.mkOption {
      type = lib.types.str;
      default = value;
      readOnly = true;
    };
in
{
  options.my.programs.shell = {
    exe = mkReadOnlyStrOption (lib.getExe config.programs.bash.package);
    args = {
      login = mkReadOnlyStrOption "-l";
      cmd = mkReadOnlyStrOption "-c";
    };
  };

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
          };
        };

      };

      my.programs.editor.lsp.bash-language-server = {
        command = "${lib.getExe pkgs.bash-language-server}";
        environment.SHFMT_PATH = "${lib.getExe pkgs.shfmt}";
      };
    }

    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;

        silent = true;
        config.warn_timeout = "2m";
      };

      my.programs.editor.ignore = [
        "!.envrc"
        ".direnv"
      ];
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
              eval "$(${lib.getExe pkgs.zoxide} init bash)"    
            '';
      };
    }

    {
      home.sessionVariables = {
        STARSHIP_LOG = "error";
      };

      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
          scan_timeout = 30;
          command_timeout = 80; # default 500
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
  ];
}
