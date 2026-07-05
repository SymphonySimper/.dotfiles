{
  den.aspects.apps.tmux = {
    homeManager =
      { config, pkgs, ... }:
      let
        cfg = config.programs.tmux;

        history = pkgs.writeShellScript "my-tmux-history" ''
          temp_file=$(mktemp)

          # captures entire history
          tmux capture-pane -p -S - > "$temp_file"
          tmux new-window "$EDITOR $temp_file; rm $temp_file"
        '';
      in
      {
        catppuccin.tmux.extraConfig = # conf
          ''
            ## status
            set -g status on
            set -g status-position bottom
            set -g status-left ""
            set -g status-right ""
            set -g status-interval 5

            set -g @catppuccin_window_status_style "basic"

            setw -g automatic-rename on
            setw -g automatic-rename-format "#{pane_current_path}: #{pane_current_command}"

            set -g @catppuccin_window_text " #{pane_current_command}"
            set -g @catppuccin_window_current_text " #{pane_current_command}"

            set -ag status-right "#{E:@catppuccin_status_session}"
          '';

        programs = {
          tmux = {
            enable = true;
            prefix = "C-a";
            shortcut = "a";
            keyMode = "vi";
            escapeTime = 0;
            baseIndex = 1;
            mouse = false;
            customPaneNavigationAndResize = true;
            newSession = false;

            extraConfig = # conf
              ''
                # RGB colors
                # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
                set -as terminal-features ",${cfg.terminal}:RGB"

                setw -g monitor-activity on
                set -g visual-activity off # If enabled shows activity in window message

                # Required by yazi
                set -g allow-passthrough on
                set -ga update-environment TERM
                set -ga update-environment TERM_PROGRAM

                # UI
                ## window
                set -g renumber-window on # renumber when window is closed
                set -g window-status-separator "" # remove gap between window text

                # Keybinds
                ## y and p as in vim
                bind Escape copy-mode
                unbind p
                bind p paste-buffer
                bind-key -T copy-mode-vi "v" send -X begin-selection
                bind-key -T copy-mode-vi "y" send -X copy-selection

                ## Create new session
                bind -r C-n new

                ## split pane commands and open panes in cwd
                bind - split-window -c "#{pane_current_path}"
                bind | split-window -c "#{pane_current_path}" -h
                bind c new-window -c "#{pane_current_path}"

                ## Open External programs
                bind e run-shell  ${history} # Open history in editor
              '';
          };
        };
      };
  };
}
