{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.scripts.todo;

  todo = (
    pkgs.writeShellScriptBin "mytodo" # sh
      ''
        ${config.my.programs.editor.command} ${config.xdg.dataHome}/mytodo.md
      ''
  );
in
{
  options.my.programs.scripts.todo = {
    enable = lib.mkEnableOption "Todo";
  }
  // (lib.my.mkCommandOption {
    category = "My Todo";
    command = lib.getExe todo;
  });

  config = lib.mkIf cfg.enable {
    home.packages = [ todo ];
  };
}
