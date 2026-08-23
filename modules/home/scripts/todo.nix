{
  config,
  pkgs,
  lib,
  ...
}:
let
  script = pkgs.writeShellScriptBin "mytodo" "$EDITOR ${config.xdg.dataHome}/mytodo.md";
in
{
  options.scripts.todo = {
    enable = lib.mkEnableOption "To-Do" // {
      default = true;
    };
  };

  config = lib.mkIf config.scripts.todo.enable {
    home.packages = [ script ];

    programs.tmux.extraConfig = ''
      bind t new-window -c "#{pane_current_path}" ${lib.getExe script}
    '';
  };
}
