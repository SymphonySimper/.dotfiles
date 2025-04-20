{
  config,
  pkgs,
  lib,
  ...
}:
{
  my.desktop.keybinds = [
    {
      key = "d";
      cmd = lib.getExe (
        pkgs.writeShellScriptBin "mylauncher" # sh
          ''
            cmd=$(${lib.getExe' config.programs.tofi.package "tofi-drun"})
            if [[ -n "$cmd" ]]; then
              ${config.my.desktop.uwsm} $cmd
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
}
