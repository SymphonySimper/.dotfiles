{
  pkgs,
  lib,
  config,
  my,
  ...
}:
let
  statusPosition = "top";
  windowFormat = # tmux
    " #{b:pane_current_path}";
  terminalFeatures = if my.profile == "wsl" then "xterm-256color" else my.programs.terminal;
in
{
  home.packages = with pkgs; [ acpi ];
  programs = {
    zsh.initExtra = # sh
      ''
        # Auto start tmux
        if [ -z "''${TMUX}" ]; then
            exec ${lib.getExe pkgs.tmux} -f "${config.xdg.configHome}/tmux/tmux.conf" new >/dev/null 2>&1
        fi
      '';
    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      prefix = "C-a";
      shortcut = "a";
      keyMode = "vi";
      escapeTime = 0;
      baseIndex = 1;
      mouse = true;
      customPaneNavigationAndResize = true;
      newSession = false;
      catppuccin.extraConfig = # tmux
        ''
          # Remove background of status bar
          set -g @catppuccin_status_background "none"

          set -g @catppuccin_window_text "${windowFormat}"
          set -g @catppuccin_window_current_text "${windowFormat}"
          set -g @catppuccin_date_time_text " %H:%M %d/%m"

          # status
          set -g status-interval 60
          set -g status-position "${statusPosition}"

          set -g status-left ""
          set -g status-left-length 100

          set -g status-right ""
          set -g status-right-length 100
        '';
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.battery;
          extraConfig = # tmux
            ''
              if "test -r /sys/class/power_supply/BAT*" {
                set -agF status-right "#{E:@catppuccin_status_battery}"
              }
              set -agF status-right "#{E:@catppuccin_status_date_time}"
            '';
        }
      ];
      extraConfig = # tmux
        ''
          # RGB colors
          # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
          set -as terminal-features ",${terminalFeatures}:RGB"

          # For yazi
          set -g allow-passthrough on

          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM

          setw -g monitor-activity on
          set -g visual-activity off # If enabled shows activity in window message

          # Turn off automatic renaming
          setw -g automatic-rename off

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
          bind-key -T copy-mode-vi "Space" send -X halfpage-down
          bind-key -T copy-mode-vi "Bspace" send -X halfpage-up

          ## easy-to-remember split pane commands and open panes in cwd
          unbind '"'
          unbind %
          unbind "'"
          bind - split-window -c "#{pane_current_path}"
          bind | split-window -hc "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"

          ## Maximize pane
          bind -r m resize-pane -Z

          ## Open a pane with 30% width
          bind -r '"' split-window -h -l '30%' -c "#{pane_current_path}"
          bind -r "'" split-window -v -l '20%' -c "#{pane_current_path}"

          ## Sync pane
          bind -r b set-window-option synchronize-panes

          ## Create new session
          bind -r C-n new

          ## Reload config with prefix+r
          bind r source-file "${config.xdg.configHome}/tmux/tmux.conf"
        '';
    };
  };
}
