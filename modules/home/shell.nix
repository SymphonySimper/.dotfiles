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

  cd = {
    plugin = "mycd";
    getPaths = "__my_cd_paths";
  };
in
{
  imports = [
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "env" ] [ "home" "sessionVariables" ])
    (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "path" ] [ "home" "sessionPath" ])

    # (lib.modules.mkAliasOptionModule [ "my" "programs" "shell" "root" ] [ "programs" "bash" ])
  ];

  options.my.programs.shell = {
    nu = {
      autoload = lib.mkOption {
        type = lib.types.attrsOf lib.types.lines;
        description = "Files/Content to add to $nu.user-autload-dirs";
        default = { };
      };
    }
    // (lib.my.mkCommandOption {
      category = "Interactive Shell";
      command = "nu";
      args = {
        command = "--commands";
        login = "--login";
      };
    });

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
            def killall [--force (-f)] {
              let programs = (ps)

              match ($programs | get name | uniq | input list --fuzzy) {
                null => "No program was selected"
                $program => { $programs | where name == $program | kill --force=$force ...($in.pid) }
              }
            }
          ''

          ''
            let __my_cd_db = ($nu.default-config-dir | path join "cd.sqlite")

            if not ($__my_cd_db | path exists) {
              { foo: "bar" } | into sqlite --table-name foo $__my_cd_db

              open $__my_cd_db | query db "DROP TABLE foo"
              open $__my_cd_db | query db "CREATE TABLE main (path TEXT PRIMARY KEY NOT NULL)"
              open $__my_cd_db | query db "CREATE INDEX index_path_length ON main(length(path))"
              open $__my_cd_db | query db "INSERT INTO main (path) VALUES (?)" --params [$nu.home-path]
            }

            def __my_cd_add_path [path: string] {
              open $__my_cd_db | query db "INSERT OR IGNORE INTO main (path) VALUES (?)" --params [$path]
            }

            def __my_cd_delete_path [path: string] {
              open $__my_cd_db | query db "DELETE FROM main WHERE path = ?" --params [$path]
            }

            def __my_cd_search [args: list<string>] {
              mut path = null

              loop {
                $path = (
                  open $__my_cd_db |
                  query db "SELECT path FROM main WHERE path LIKE ? ORDER BY LENGTH(path) LIMIT 1" --params [$"%($args | str join '%')%"] |
                  get 0.path --optional
                )

                match $path {
                  null => break
                  $path if ($path | path exists) => break
                  $path => { __my_cd_delete_path $path }
                }
              }

              return $path
            }

            def --env --wrapped z [...args] {
              match $args {
                [] => { cd ~ }
                ["-"] => { cd - }
                [$path] if ($path | path exists) => {
                  let absolute_path = match ($path | path type) {
                    "dir" => ($path | path expand)
                    "file" => ($path | path expand | path dirname)
                    "symlink" => {
                      let absolute_path = ($path | path expand --no-symlink)

                      match (ls --full-paths --all $absolute_path | get name) {
                        [$link] if $link == $absolute_path => ($absolute_path | path dirname)
                        _ => $absolute_path
                      }
                    }
                  }

                  __my_cd_add_path $absolute_path

                  cd $absolute_path 
                }
                _ => {
                  match (__my_cd_search $args) {
                    null => { error make {msg: $"($args) not found or doesn't exist"} } 
                    $path => { cd $path }
                  }
                }
              }
            }

            def ${cd.getPaths} [--no-check] {
              let paths = (
                open $__my_cd_db |
                query db "SELECT path FROM main ORDER BY LENGTH(path)" |
                get path
              )

              if $no_check {
                return $paths
              }

              $paths | where ($it | path exists)
            }

            def --env zi [] {
              match (${cd.getPaths} | input list --fuzzy) {
                null => "No dir was chosen."
                $dir => { cd $dir }
              }
            }

            def zd [] {
              match (${cd.getPaths} --no-check | input list --fuzzy) {
                null => "No dir was chosen."
                $dir => {
                  __my_cd_delete_path $dir
                  print $"Deleted: ($dir)"
                }
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

      yazi.keymap = {
        mgr.prepend_keymap = [
          {
            run = "plugin ${cd.plugin}";
            on = [ "z" ];
          }
          {
            run = "noop";
            on = [ "Z" ];
          }
        ];
      };
    };

    xdg.configFile = {
      "yazi/plugins/${cd.plugin}.yazi/main.lua".text = ''
        return {
          entry = function()
            local _permit = ya.hide()

            local child, err1 = Command("${cfg.nu.command}")
                :arg({ "${cfg.nu.args.login}", "${cfg.nu.args.command}", "__my_cd_paths | input list --fuzzy" })
                :stdout(Command.PIPED)
                :stderr(Command.INHERIT)
                :spawn()

            if not child then
              return
            end

            local output, _ = child:wait_with_output()
            local target = output.stdout:gsub("\n$", "")

            if target ~= "" then
              ya.emit("cd", { target, raw = true })
            end
          end
        }
      '';
    };

    home.file = builtins.listToAttrs (
      map (
        file:
        let
          key = if (lib.strings.hasPrefix "/" file.value) then "source" else "text";
        in
        {
          name = "${config.programs.nushell.configDir}/autoload/${file.name}.nu";
          value.${key} = file.value;
        }
      ) (lib.attrsets.attrsToList cfg.nu.autoload)
    );
  };
}
