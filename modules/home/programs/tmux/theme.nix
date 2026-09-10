{ config, ... }:
let
  color = config.theme.color;
  accent = color.${config.theme.accent};
in
{
  catppuccin.tmux.enable = false;

  programs.tmux.extraConfig = ''
    set -g message-style "fg=${color.teal.hex},bg=${color.mantle.hex},align=centre"
    set -g message-command-style "fg=${color.teal.hex},bg=${color.mantle.hex},align=centre"
    set -g menu-selected-style "fg=${color.text.hex},bold,bg=${color.overlay0.hex}"
    set -g popup-style "bg=${color.base.hex},fg=${color.text.hex}"
    set -g popup-border-style "fg=${color.surface1.hex}"
    set -g mode-style "bg=${color.surface0.hex},bold"
    set -g clock-mode-colour "${color.blue.hex}"

    ## pane
    set -wg pane-border-style "fg=${color.overlay0.hex}"
    set -wg pane-active-border-style "#{?pane_in_mode,fg=${color.lavender.hex},#{?pane_synchronized,fg=${accent.hex},fg=${color.lavender.hex}}}"

    ## status
    set -g status-style "bg=${color.mantle.hex},fg=${color.text.hex}"
    set -g status-right '#[fg=#{?client_prefix,${color.red.hex},${color.green.hex}}]#[fg=${color.crust.hex},bg=#{?client_prefix,${color.red.hex},${color.green.hex}}] #[fg=${color.text.hex},bg=${color.surface0.hex}] #S#[fg=${color.surface0.hex}] '

    ## window
    set -g window-status-format "#[fg=${color.crust.hex},bg=${color.overlay2.hex}] #I #[fg=${color.text.hex},bg=${color.surface0.hex}] #{?automatic-rename,#{pane_current_command},#{window_name}} "
    set -g window-status-current-format "#[fg=${color.crust.hex},bg=${accent.hex}] #I #[fg=${color.text.hex},bg=${color.surface1.hex}] #{?automatic-rename,#{pane_current_command},#{window_name}} "
    set -g window-status-activity-style "bg=${color.lavender.hex},fg=${color.crust.hex}"
    set -g window-status-bell-style "bg=${color.yellow.hex},fg=${color.crust.hex}"
  '';
}
