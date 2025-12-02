{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.shell;

  mkNuCacheFile = file: "$\"($nu.cache-dir)/${file}\"";
in
{
  imports = [
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "env" ] [ "home" "sessionVariables" ])
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "path" ] [ "home" "sessionPath" ])

    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "root" ] [ "programs" "bash" ])
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "nu" "root" ] [ "programs" "nushell" ])
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "prompt" ] [ "programs" "starship" ])
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
      user = lib.my.mkCommandOption {
        category = "User shell";
        command = "nu";
        args = {
          command = "--commands";
        };
      };

      addToPath = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "Add a executable to ~/.local/bin";
        default = { };
      };

      nu = {
        config = lib.mkOption {
          type = lib.types.lines;
          description = "Config to include in generated config";
        };

        env = lib.mkOption {
          type = lib.types.lines;
          description = "Env to include in generated env";
        };
      };

      common = {
        env = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Common env to include in both the shells";
          default = { };
        };
      };
    };

  config = lib.mkMerge [
    {
      home.shellAliases = {
        q = "exit";
      };

      my.programs.shell = {
        common.env = {
          LS_COLORS = ""; # Some programs misbehave when this is not set.
        };

        env = cfg.common.env;
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

    (
      let
        common = {
          config = "common/config.nu";
          env = "common/env.nu";
          theme = "common/theme.nu";
        };

        mkCommonImport = file: ''source $"($nu.default-config-dir)/${common.${file}}"'';
      in
      {
        catppuccin.nushell.enable = false;

        programs.nushell = {
          enable = true;

          extraConfig = lib.mkAfter (mkCommonImport "config");
          extraEnv = lib.mkAfter (mkCommonImport "env");
        };

        home.file = {
          "${cfg.nu.root.configDir}/${common.config}".text = cfg.nu.config;
          "${cfg.nu.root.configDir}/${common.env}".text = cfg.nu.env;
          "${cfg.nu.root.configDir}/${common.theme}".source = lib.my.mkGetThemeSource {
            package = "nushell";
            filename = "NAME_FLAVOR.nu";
            returnFile = true;
          };
        };

        my.programs = {
          shell.nu = {
            env =
              lib.mkBefore # nu
                ''
                  ${lib.strings.concatLines (
                    builtins.map (env: "$env.${env.name} = '${env.value}'") (lib.attrsets.attrsToList cfg.common.env)
                  )}

                  if not ($nu.cache-dir | path exists) {
                    mkdir $nu.cache-dir
                  }
                '';

            config =
              lib.mkBefore # nu
                ''
                  ${mkCommonImport "theme"}
                   
                  $env.config.show_banner = false

                  $env.config.buffer_editor = "${config.my.programs.editor.command}"

                  $env.config.history.file_format = "sqlite"
                  $env.config.history.isolation = true

                  $env.config.completions.algorithm = "fuzzy"
                  $env.config.completions.external.max_results = 20

                  $env.config.datetime_format.normal = "%d/%m/%y %I:%M:%S%p"

                  $env.config.filesize.unit = "metric"
                  $env.config.filesize.show_unit = true
                '';
          };

          copy.of = (
            builtins.map (file: {
              from = "CONFIG/nushell/${file}";
              to = "WINDOWS/nushell/${file}";
            }) (builtins.attrValues common)
          );
        };
      }
    )

    {
      programs.carapace = {
        enable = true;
        enableNushellIntegration = false;
      };

      my.programs.shell.nu =
        let
          file = mkNuCacheFile "carapace.nu";
        in
        {
          env = # nu
            ''
              if not ("${file}" | path exists) {
                carapace _carapace nushell | save -f ${file}
              }
            '';

          config = "source ${file}";
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
          enableNushellIntegration = false;
        };
      };

      my.programs.shell = {
        root.initExtra = lib.mkOrder 4000 ''eval "$(zoxide init bash)"'';

        nu =
          let
            file = mkNuCacheFile "zoxide.nu";
          in
          {
            env = # nu
              ''
                if not ("${file}" | path exists) {
                  zoxide init nushell | save -f ${file}
                }
              '';

            config = lib.mkOrder 4000 "source ${file}";
          };

      };
    }

    {
      my.programs.shell.env.STARSHIP_LOG = "error";

      programs.starship = {
        enable = true;
        enableNushellIntegration = false;

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

      my.programs.shell.nu =
        let
          file = mkNuCacheFile "starship.nu";
        in
        {
          env = # nu
            ''
              if not ("${file}" | path exists) {
                starship init nu | save -f ${file}
              }
            '';

          config = "source ${file}";
        };
    }
  ];
}
