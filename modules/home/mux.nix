{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  defaultTerminal = if my.profile == "wsl" then "xterm-256color" else my.programs.terminal;

  history = lib.getExe (
    let
      mkCoreutil = name: lib.getExe' pkgs.coreutils name;
    in
    pkgs.writeShellScriptBin "my-tmux-history" # sh
      ''
        temp_file=$(${mkCoreutil "mktemp"})

        # captures entire history
        tmux capture-pane -p -S - > "$temp_file"
        tmux new-window "${my.programs.editor} $temp_file; ${mkCoreutil "rm"} $temp_file"
      ''
  );
in
{
  my.programs.terminal.shell.cmd = "tmux new";

  programs = {
    tmux = {
      enable = true;
      terminal = defaultTerminal;
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
          set -g default-command "exec ${config.my.programs.shell.exe}"

          # RGB colors
          # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
          set -as terminal-features ",${defaultTerminal}:RGB"

          # For yazi
          set -g allow-passthrough on

          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM

          setw -g monitor-activity on
          set -g visual-activity off # If enabled shows activity in window message

          # Turn off automatic renaming
          setw -g automatic-rename off

          # UI
          ## status
          set -g status off

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

          ## Open program in new window
          bind -r g new-window -c "#{pane_current_path}" "${lib.getExe config.programs.lazygit.package}"
          bind -r y new-window -c "#{pane_current_path}" "${lib.getExe config.programs.yazi.package}"

          ## Open history in editor
          bind -r e run-shell "${history}" 

          ## easy-to-remember split pane commands and open panes in cwd
          unbind '"'
          unbind %
          unbind "'"
          bind - split-window -c "#{pane_current_path}"
          bind | split-window -hc "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"

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
