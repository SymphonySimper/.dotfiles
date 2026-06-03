{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "my-cd-bookmarks";
  file = "${config.xdg.dataHome}/${name}.txt";
in
{
  my.programs = {
    shell.fish = {
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

                    set -l cd_path_with_length "$(string length "$cd_path") $cd_path"
                    if not string match --quiet --regex "^$cd_path_with_length\$" <$_my_cd_bookmarks_file
                        echo "$cd_path_with_length" >> $_my_cd_bookmarks_file
                        sort --numeric-sort $_my_cd_bookmarks_file --output $_my_cd_bookmarks_file
                    end
                else
                  set -l matches (string match --ignore-case --entire --regex "$(string join ".*" $argv)" < $_my_cd_bookmarks_file)
                  set -l dead_bookmarks

                  for match in $matches
                      set -l match_path  (string replace --regex '^\d+[[:space:]]' "" $match)
                      if test -d "$match_path"
                          set cd_path $match_path
                          break
                      else
                          set -a dead_bookmarks "$match"
                      end
                  end

                  if set -q dead_bookmarks[1]
                      set -l dead_regex "^("(string join "|" (string escape --style=regex $dead_bookmarks))")\$"
                      set -l bookmarks (string split '\n' <$_my_cd_bookmarks_file)
                      string match --invert --regex "$dead_regex" $bookmarks > $_my_cd_bookmarks_file
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

    file-manager.yazi.keymap = {
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
      script = lib.getExe (
        pkgs.writeShellScriptBin "${name}-yazi-script" ''
          ${lib.getExe config.programs.fzf.package} < "${file}"
        ''
      );
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
}
