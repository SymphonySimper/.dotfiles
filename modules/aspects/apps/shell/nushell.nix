{ lib, ... }: {
  den.aspects.apps.shell.nushell = {
    homeManager =
      { config, ... }:
      let
        shared = import ./_shared.nix { inherit config; };
      in
      {
        programs.nushell = {
          enable = true;

          settings = {
            show_banner = false;
            buffer_editor = "$EDITOR";
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
              let __my_prompt_color = (ansi --escape { fg: '${shared.prompt.color.hex}', attr: b })

              $env.PROMPT_COMMAND = {|| $"($__my_prompt_color)($env.PWD | str replace $nu.home-dir '~')\n" }
              $env.PROMPT_INDICATOR = $"($__my_prompt_color)${shared.prompt.arrow}(ansi reset) "
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
      };
  };
}
