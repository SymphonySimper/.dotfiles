{ config, ... }:
let
  bookmarksFile = "${config.xdg.dataHome}/my-cd-bookmarks.txt";
in
{
  my.programs = {
    shell.fish = {
      interactiveShellInit = ''
        set _my_cd_bookmarks_file ${bookmarksFile}

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
                set cd_path # path to cd to

                if test -e $argv[1]
                    set query_as_path (builtin realpath --no-symlinks $argv[1])
                    if test -d $query_as_path
                        set cd_path $query_as_path
                    else if test -f $query_as_path
                        set cd_path (path dirname $query_as_path)
                    end

                    if not string match --quiet --regex "^$cd_path\$" <$_my_cd_bookmarks_file
                        echo $cd_path >>$_my_cd_bookmarks_file

                        for bookmark in (sort $_my_cd_bookmarks_file)
                            echo "$(string length "$bookmark") $bookmark"
                        end | sort -n | string replace -r '^\d+[[:space:]]' "" >$_my_cd_bookmarks_file
                    end
                else
                    read --list --null bookmarks <$_my_cd_bookmarks_file
                    set query (string join ".*" $argv)
                    for bookmark in $bookmarks
                        if string match --quiet --ignore-case --regex "$query" "$bookmark"
                            if not test -d "$bookmark"
                                set temp_file "/tmp/my-cd-bookmarks-$(random).txt"
                                string match --invert --regex "^$bookmark\$" <$_my_cd_bookmarks_file >$temp_file
                                mv $temp_file $_my_cd_bookmarks_file
                            else
                                set cd_path $bookmark
                                break
                            end
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
  };
}
