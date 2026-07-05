{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.scripts.todo;

  todo = pkgs.writeShellScriptBin "mytodo" ''
    ${config.my.programs.editor.command} ${config.xdg.dataHome}/mytodo.md
  '';
in
{
  options.my.programs.scripts.todo = {
    enable = lib.mkEnableOption "Todo";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ todo ];

    my.programs.mux.keybinds = [
      {
        key = "t";
        command = lib.getExe todo;
      }
    ];
  };
}
