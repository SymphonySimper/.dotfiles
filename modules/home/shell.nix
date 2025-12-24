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
    nu = lib.my.mkCommandOption {
      category = "Interactive Shell";
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

      shell = {
        env = {
          LS_COLORS = ""; # Some programs misbehave when this is not set.
          STARSHIP_LOG = "error";
        };

        path = [ binPath.absolute ];
      };
    };

    xdg.dataFile = builtins.listToAttrs (
      builtins.map (file: {
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

      nushell = {
        enable = true;

        extraConfig = lib.strings.concatLines [
          ''
            $env.config.show_banner = false;

            $env.config.buffer_editor = "${config.my.programs.editor.command}";

            $env.config.history.file_format = "sqlite";
            $env.config.history.isolation = true;

            $env.config.completions.algorithm = "fuzzy";
            $env.config.completions.external.max_results = 20;

            $env.config.datetime_format.normal = "%d/%m/%y %I:%M:%S%p";

            $env.config.filesize.unit = "metric";
            $env.config.filesize.show_unit = true;
          ''

          (
            # refer: https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/default_files/default_env.nu
            let
              color = "ansi --escape { fg: '${prompt.color.hex}', attr: b }";
            in
            ''
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

          ''
            def --env mydev [] {
              let dir = (
                glob --depth 2 --no-file --exclude [**/.*/**] ${my.dir.dev}/** |
                each {|row| $row | str replace $nu.home-path "~" } |
                prepend "~/.dotfiles" |
                input list --fuzzy
              )

              match $dir {
                null => "No dir was chosen."
                _ => { cd $dir }
              }
            }
          ''

          ''
            let __my_cd_db = ($nu.default-config-dir | path join "cd.db")

            def __my_cd_paths [] {
              if not ($__my_cd_db | path exists) {
                { path: $nu.home-path } | into sqlite $__my_cd_db

                print $"DB created at ($__my_cd_db)"
              }

              open $__my_cd_db |
              query db "SELECT path FROM main ORDER BY LENGTH(path)" |
              get path |
              where ($it | path exists)
            }

            def --env z [arg] {
              let raw_paths = (__my_cd_paths) 

              if ($arg | path exists) {
                let absolute_path = $arg | path expand

                if $absolute_path not-in $raw_paths {
                  open $__my_cd_db | query db "INSERT INTO main (path) VALUES (?)" --params [$absolute_path]
                }

                cd $absolute_path 
              } else {
                let paths =  $raw_paths | find -r $arg 

                if ($paths | length | $in > 0) {
                  cd ($paths | first) 
                } else {
                  error make {msg: $"($arg) not found or doesn't exist"}
                }
              } 
            }

            def --env zi [] {
              let dir = (__my_cd_paths | input list --fuzzy)

              match $dir {
                null => "No dir was chosen."
                _ => { cd $dir }
              }
            }
          ''
        ];
      };

      carapace.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;

        silent = false;
        config.warn_timeout = "2m";
      };
    };
  };
}
