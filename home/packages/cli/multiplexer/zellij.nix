{ pkgs, userSettings, ... }:
{
  programs.zellij = {
    enable = userSettings.programs.multiplexer == "zellij";
    enableZshIntegration = true;
    settings = {
      on_force_close = "detach";
      default_shell = "${pkgs.zsh}/bin/zsh";
      simplified_ui = true;
      pane_frames = false;
      default_layout = "compact";
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };

      # Disable session resurruction
      session_serialization = false;
      pane_viewport_serialization = false;
    };
  };
}
