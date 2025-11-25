{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.mux;
  defaultTerminal =
    if my.profile == "wsl" then "xterm-256color" else config.my.programs.terminal.command;

  history = lib.getExe (
    pkgs.writeShellScriptBin "my-tmux-history" # sh
      ''
        temp_file=$(mktemp)

        # captures entire history
        tmux capture-pane -p -S - > "$temp_file"
        tmux new-window "${config.my.programs.editor.command} $temp_file; rm $temp_file"
      ''
  );
in
{
  options.my.programs.mux =
    (lib.my.mkCommandOption {
      category = "Terminal Mux";
      command = "tmux";
      args = {
        new = "new";
      };
    })
    // {
      enable = lib.mkEnableOption "Terminal MUX";

      keybinds = lib.mkOption {
        description = "MUX keybinds";
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              repeat = lib.mkEnableOption "Repeat key";

              unbind = lib.mkEnableOption "Unbid key";
              key = lib.mkOption {
                description = "Key for action";
                type = lib.types.str;
              };

              action = lib.mkOption {
                description = "Action to perfom on keybind";
                type = lib.types.enum [
                  "new-window"
                  "run-window"
                  "split-window"

                  "run-shell"
                  "display-popup"
                ];
              };
              cd = lib.mkEnableOption "CD";
              args = lib.mkOption {
                description = "Args for action";
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
          }
        );
        default = [ ];
      };
    };

  config = lib.mkIf cfg.enable {
    my.programs = {
      mux.keybinds = [
        # Open program in new window
        {
          key = "g";
          action = "new-window";
          cd = true;
          args = [ (config.my.programs.vcs.tui.command) ];
        }
        {
          key = "y";
          action = "new-window";
          cd = true;
          args = [ (config.my.programs.file-manager.command) ];
        }

        # Open history in editor
        {
          key = "e";
          action = "run-shell";
          args = [ history ];
        }

        # split pane commands and open panes in cwd
        {
          key = "-";
          action = "split-window";
          cd = true;
        }
        {
          key = "|";
          action = "split-window";
          cd = true;
          args = [ "-h" ];
        }
        {
          key = "c";
          action = "new-window";
          cd = true;
        }
      ];
    };

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
      '';

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

        extraConfig = lib.strings.concatLines (
          builtins.concatLists [
            [
              # conf
              ''
                set -g default-command "exec ${config.my.programs.shell.command}"

                # RGB colors
                # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
                set -as terminal-features ",${defaultTerminal}:RGB"

                setw -g monitor-activity on
                set -g visual-activity off # If enabled shows activity in window message

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
              ''
            ]

            (builtins.concatMap (
              keybind:
              (lib.optionals keybind.unbind [
                "unbind ${keybind.key}"
              ])
              ++ [
                (builtins.concatStringsSep " " (
                  [
                    "bind"
                    (lib.strings.optionalString keybind.repeat "-r")
                    keybind.key
                    keybind.action
                    (lib.strings.optionalString keybind.cd (
                      let
                        arg = if keybind.action == "display-popup" then "-d" else "-c";
                      in
                      "${arg} \"#{pane_current_path}\""
                    ))
                  ]
                  ++ keybind.args
                ))
              ]
            ) cfg.keybinds)
          ]
        );
      };
    };
  };
}
