{
  pkgs,
  config,
  userSettings,
  profileSettings,
  ...
}:
{
  programs.tmux = {
    enable = userSettings.programs.multiplexer == "tmux";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    prefix = "C-a";
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    newSession = true;
    plugins = with pkgs; [ tmuxPlugins.sensible ];
    extraConfig = ''
      # RGB colors
      # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
      set-option -as terminal-features ',${
        if profileSettings.profile == "wsl" then "xterm-256color" else userSettings.programs.terminal
      }:RGB'

      # For yazi
      set -g allow-passthrough on

      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      # Attach to different session on exit
      set-option -g detach-on-destroy on

      setw -g monitor-activity on
      set -g visual-activity on

      # Turn off automatic renaming
      setw -g automatic-rename off

      # y and p as in vim
      bind Escape copy-mode
      unbind p
      bind p paste-buffer
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      bind-key -T copy-mode-vi 'Space' send -X halfpage-down
      bind-key -T copy-mode-vi 'Bspace' send -X halfpage-up

      # easy-to-remember split pane commands and open panes in cwd
      unbind '"'
      unbind %
      unbind "'"
      bind - split-window -c "#{pane_current_path}"
      bind | split-window -hc "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # moving between windows with vim movement keys
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Maximize pane
      bind -r m resize-pane -Z

      # Open a pane with 30% width
      bind -r '"' split-window -h -l '30%' -c "#{pane_current_path}"
      bind -r "'" split-window -v -l '20%' -c "#{pane_current_path}"

      # Sync pane
      bind -r b set-window-option synchronize-panes

      # Create new session
      bind -r C-n new

      # Reload config with prefix+r
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf
    '';
  };
}
