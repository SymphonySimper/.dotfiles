{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.mux;
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
  options.my.programs.mux = {
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
      terminal.shell.cmd = "tmux new";

      mux.keybinds = [
        # Open program in new window
        {
          key = "g";
          action = "new-window";
          cd = true;
          args = [ (lib.getExe config.programs.lazygit.package) ];
        }
        {
          key = "y";
          action = "new-window";
          cd = true;
          args = [ (lib.getExe config.programs.yazi.package) ];
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

        ## Open a pane with 30% width
        {
          unbind = true;
          key = "'\"'";
          action = "split-window";
          cd = true;
          args = [
            "-h"
            "-l '30%'"
          ];
        }
        {
          unbind = true;
          key = "\"'\"";
          action = "split-window";
          cd = true;
          args = [
            "-v"
            "-l '20%'"
          ];
        }
      ];
    };

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

                ## Sync pane
                bind -r b set-window-option synchronize-panes

                ## Create new session
                bind -r C-n new

                ## Reload config with prefix+r
                bind r source-file "${config.xdg.configHome}/tmux/tmux.conf"
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
