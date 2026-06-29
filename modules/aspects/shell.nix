{
  den.aspects.shell.homeManager =
    {
      user,
      config,
      lib,
      ...
    }:
    let
      cfg = config.my.aspects.shell;

      binPath = rec {
        relative = "../bin"; # relative to XDG_DATA_HOME
        absolute = "${config.xdg.dataHome}/${relative}";
      };

      prompt = {
        arrow = ">";
        color = user.theme.color.lavender;
      };
    in
    {
      options.my.aspects.shell = {
        addToPath = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Add a executable to ~/.local/bin";
          default = { };
        };

        direnv.enable = lib.mkEnableOption "Enable direnv";
      };

      config = {
        home.sessionVariables = {
          LS_COLORS = ""; # Some programs misbehave when this is not set.
        };
        home.sessionPath = [ binPath.absolute ];

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
            };
          };

          nushell = {
            enable = true;

            settings = {
              show_banner = false;
              buffer_editor = config.my.programs.editor.command;
              completions.algorithm = "fuzzy";
              datetime_format.normal = "%d/%m/%y %I:%M:%S%p";

              history = {
                file_format = "sqlite";
                isolation = true;
              };

              filesize = {
                unit = "metric";
                show_unit = true;
              };
            };

            extraConfig = lib.strings.concatLines [
              # refer: https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/default_files/default_env.nu
              #
              ''
                let __my_prompt_color = (ansi --escape { fg: '${prompt.color.hex}', attr: b })

                $env.PROMPT_COMMAND = {|| $"($__my_prompt_color)($env.PWD | str replace $nu.home-dir '~')\n" }
                $env.PROMPT_INDICATOR = $"($__my_prompt_color)${prompt.arrow}(ansi reset) "
                $env.PROMPT_COMMAND_RIGHT = ""
              ''

              ''
                def killall [--force (-f)] {
                  let programs = (ps)

                  match ($programs | get name | uniq | input list --fuzzy) {
                    null => "No program was selected"
                    $program => { $programs | where name == $program | kill --force=$force ...($in.pid) }
                  }
                }
              ''
            ];
          };

          direnv = {
            enable = lib.mkForce cfg.direnv.enable;
            nix-direnv.enable = true;

            silent = false;
            config.warn_timeout = "2m";
          };
        };
      };
    };
}
