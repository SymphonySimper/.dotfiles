{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.programs.desktop.enable {
    my.programs.desktop.keybinds = [
      {
        key = "d";
        command = lib.getExe (
          pkgs.writeShellScriptBin "mylauncher" # sh
            ''
              command=$(${lib.getExe' config.programs.tofi.package "tofi-drun"})
              if [[ -n "$command" ]]; then
                exec ${config.my.programs.desktop.uwsm} $command
              fi
            ''
        );
      }
    ];

    programs.tofi = {
      enable = true;
      settings = {
        ascii-input = true;
        late-keyboard-init = false;

        width = "100%";
        height = "100%";
        border-width = 0;
        outline-width = 0;
        padding-left = "35%";
        padding-top = "35%";
        result-spacing = 25;
        num-results = 5;

        # cd $(nix build nixpkgs#nerd-fonts.jetbrains-mono --print-out-paths --no-link)/share/fonts/truetype/NerdFonts/JetBrainsMono
        font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
      };
    };

    home.activation = {
      # refer: https://github.com/philj56/tofi/issues/115#issuecomment-1950273960
      myRmTofiCache =
        lib.hm.dag.entryAfter [ "writeBoundary" ] # sh
          ''
            tofi_cache=${config.xdg.cacheHome}/tofi-drun
            [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
          '';
    };
  };
}
