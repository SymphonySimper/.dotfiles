{ lib, ... }: {
  den.aspects.scripts.todo = {
    homeManager =
      { config, pkgs, ... }:
      let
        todo = pkgs.writeShellScriptBin "mytodo" "$EDITOR ${config.xdg.dataHome}/mytodo.md ";
      in
      {
        home.packages = [ todo ];

        programs.tmux.extraConfig = ''
          bind t new-window -c "#{pane_current_path}" ${lib.getExe todo}
        '';
      };
  };
}
