{ config, pkgs, ... }:
let
  dir = config.xdg.userDirs.projects;

  projects = pkgs.writeShellScript "my-tmux-projects" ''
    dirs=$(find "${dir}" -mindepth 1 -maxdepth 2 -type d -printf "%P\n" 2>/dev/null)

    if [ -z "$dirs" ]; then
      tmux display-message "No projects found in ${dir}"
      exit 1
    fi

    name=$(echo "$dirs" | fzf)
    if [ -z "$name" ]; then
      exit 0
    fi

    # without the `=` sign tmux performs a prefix match
    exact_session_name="=''${name}"
    # without the `:` at the end `switch-client` will try to expand `.`, `:`, `%` (refer: man tmux)
    forced_session_name="''${name}:"

    if tmux has-session -t "$exact_session_name" 2>/dev/null; then
      tmux switch-client -t "$forced_session_name"
    else
      full_path="${dir}/$name"

      if [ "$(tmux display-message -p '#{session_windows}')" -eq 1 ]; then
        tmux rename-session "$name"
        tmux send-keys -t :1 "cd $full_path && clear" Enter
      else
        tmux new-session -d -s "$name" -c "$full_path"
        tmux switch-client -t "$forced_session_name"
      fi
    fi
  '';
in
{
  programs.tmux.extraConfig = ''
    bind P display-popup -E ${projects}
  '';
}
