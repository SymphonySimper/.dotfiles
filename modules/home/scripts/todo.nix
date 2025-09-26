{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.scripts.todo;

  todo = pkgs.writeShellScriptBin "mytodo" ''
    $EDITOR ${config.xdg.dataHome}/mytodo.md
  '';
in
{
  options.my.programs.scripts.todo.enable = lib.mkEnableOption "ToDo";

  config = lib.mkIf cfg.enable {
    home.packages = [ todo ];

    my.programs.mux.keybinds = [
      {
        key = "t";
        action = "new-window";
        args = [ (lib.getExe todo) ];
      }
    ];
  };
}
