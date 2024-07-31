{ pkgs, userSettings, ... }:
{
  programs.tmux = {
    enable = userSettings.programs.multiplexer == "tmux";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    prefix = "C-a";
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 1;
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
        '';

      }
    ];
    extraConfig = ''
      # Fix wrong color nvim
      # refer https://stackoverflow.com/a/70718222/14014098
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # Attach to different session on exit
      set-option -g detach-on-destroy on

      setw -g monitor-activity on
      set -g visual-activity on

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
      bind r source-file $HOME/.config/tmux/tmux.conf
    '';
  };
}
