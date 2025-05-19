{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  defaultTerminal = if my.profile == "wsl" then "xterm-256color" else my.programs.terminal;

  profile = "${my.dir.home}/.profile";
  mkProfileScript =
    name: cmd:
    lib.getExe (
      pkgs.writeShellScriptBin name # sh
        ''
          if [ -f "${profile}" ]; then
            source "${profile}"
          fi

          ${cmd}
        ''
    );
in
{
  programs = {
    bash.initExtra = # sh
      ''
        # Auto start tmux
        if [ -z "''${TMUX}" ]; then
            exec ${lib.getExe pkgs.tmux} -f "${config.xdg.configHome}/tmux/tmux.conf" new >/dev/null 2>&1
        fi
      '';

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

      extraConfig = # tmux
        ''
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
          bind -r g new-window -c "#{pane_current_path}" "${mkProfileScript "tmuxlazygit" (lib.getExe pkgs.lazygit)}"
          bind -r y new-window -c "#{pane_current_path}" "${mkProfileScript "tmuxyazi" (lib.getExe pkgs.yazi)}"

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
