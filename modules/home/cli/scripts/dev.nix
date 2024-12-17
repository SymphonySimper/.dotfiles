{ pkgs, my, ... }:
let
  fzf = "${pkgs.fzf}/bin/fzf-tmux -p --scheme=path";
  tmux = "${pkgs.tmux}/bin/tmux";
  find = "${pkgs.findutils}/bin/find";
  ## coreutils
  basename = "${pkgs.coreutils-full}/bin/basename";
  dirname = "${pkgs.coreutils-full}/bin/dirname";
  wc = "${pkgs.coreutils-full}/bin/wc -l";
in
# sh
''
  function get_dirs() {
    dev_dirs=$(${find} "${my.dir.dev}" -maxdepth 2 -mindepth 2 -type d -not -name ".git")

    for dir in $dev_dirs; do
      parent=$(${basename} $(${dirname} "$dir"))
      echo "$parent/$(${basename} $dir)"
    done
  }

  function switch_session() {
    ${tmux} switch -t "$1:1"
  }

  selected_dir=$(get_dirs | ${fzf})
  if [[ -z "$selected_dir" ]]; then
    exit 1
  fi

  dir="${my.dir.dev}/$selected_dir"
  cd $dir || exit 1

  if tmux has-session -t "$selected_dir"; then
    switch_session "$selected_dir"
    exit 0
  fi

  current_session=$(${tmux} display-message -p "#S")
  current_window_count=$(${tmux} list-windows -t "$current_session" | ${wc})

  target_split_window=2
  if [[ $current_window_count -eq 1 ]]; then
    [[ "$selected_dir" != "$current_session" ]] && ${tmux} rename-session -t "$current_session" "$selected_dir"
    ${tmux} new-window -t "$selected_dir" -c "$dir"
    target_split_window=3
  else
    ${tmux} new-session -d -s "$selected_dir" -c $dir
  fi

  if [[ -d "$dir/client" ]] && [[ -d "$dir/server" ]]; then
    ${tmux} new-window -t "$selected_dir" -c "$dir/server"
    ${tmux} split-window -t "$selected_dir:$target_split_window" -h -c "$dir/client" 
  else
    ${tmux} new-window -t "$selected_dir" -c "$dir"
  fi

  if [[ $current_window_count -eq 1 ]]; then
    ${tmux} kill-window -t "$selected_dir":1
  else
    switch_session "$selected_dir"
  fi
''
