{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "my-cd-bookmarks";
  file = "${config.xdg.dataHome}/${name}.txt";

  addAndSortPaths = pkgs.writers.writeFish "my-z-sort-paths" ''
    set -l path (string trim $argv)
    echo "$path" >> '${file}'

    while read --line line
      echo "$(string length $line) $line"
    end < '${file}' \
      | sort --numeric-sort \
      | string replace --regex '^\d+[[:space:]]' "" > '${file}.tmp'

    mv '${file}.tmp' ${file}
  '';
in
{
  config = lib.mkIf config.my.programs.shell.fish.enable {
    programs = {
      fish = {
        interactiveShellInit = ''
          set _my_cd_bookmarks_file ${file}
          if not test -f $_my_cd_bookmarks_file
              : >$_my_cd_bookmarks_file
          end
        '';

        functions.z.body = ''
          switch "$argv[1]"
              case ""
                  cd
              case -
                  cd -
              case --edit
                  $EDITOR $_my_cd_bookmarks_file
              case "*"
                  set -l cd_path # path to cd to

                  if test -e $argv[1]
                      set -l query_as_path (builtin realpath --no-symlinks $argv[1])
                      if test -d $query_as_path
                          set cd_path $query_as_path
                      else if test -f $query_as_path
                          set cd_path (path dirname $query_as_path)
                      end

                      if not string match --quiet --regex "^$cd_path\$" <$_my_cd_bookmarks_file
                          ${addAndSortPaths} $cd_path &
                      end
                  else
                    # This method is significantly slower than previous method of
                    # finding all the matches at once and iterating over and remove
                    # all dead bookmarks at once rather than on case by case basis.
                    # But this is only true when you have a lot of dead bookmarks
                    # for a given query. This shouldn't really happen in IRL.
                    # This method is siginificantly faster for match where there is
                    # no dead bookmarks (which is most of the queries).
                    while true
                      set -l match ( \
                        string match --ignore-case \
                          --entire \
                          --regex \
                          --max-matches 1 \
                          "$(string join ".*" $argv)" < $_my_cd_bookmarks_file \
                        )

                      if test -n "$match"
                        if test -d "$match"
                          set cd_path $match
                          break
                        else 
                          set -l bookmarks (string match --invert "" <$_my_cd_bookmarks_file) # slightly faster than `string split '\n'`
                          string match --invert --regex "^$match\$" $bookmarks > $_my_cd_bookmarks_file
                        end
                      else
                        break
                      end
                    end
                  end

                  if test -z "$cd_path"
                      echo "No match found." >&2
                      return 1
                  end

                  cd $cd_path
          end
        '';
      };

      yazi.keymap = {
        mgr.prepend_keymap = [
          {
            run = "plugin ${name}";
            on = [ "z" ];
          }
          {
            run = "noop";
            on = [ "Z" ];
          }
        ];
      };
    };

    xdg.configFile."yazi/plugins/${name}.yazi/main.lua".text =
      let
        script = pkgs.writeShellScript "${name}-yazi-script" ''
          ${lib.getExe config.programs.fzf.package} < "${file}"
        '';
      in
      ''
        return {
          entry = function()
            local _permit = ui.hide()

            local child, err1 = Command("${script}")
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
}
