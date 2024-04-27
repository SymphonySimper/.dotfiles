{ ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    profileExtra = ''
      nix_loc="$HOME"/.nix-profile/etc/profile.d/nix.sh
      [ -f $nix_loc ] && . $nix_loc

      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      # [ "$(tty)" = "/dev/tty1" ] && Hyprland >/dev/null 2>&1
    '';
    initExtra = ''
      # Prompt
      precmd(){ precmd(){ echo ; }; }

      # Edit line in vim with ctrl-e:
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line

      eval "$(micromamba shell hook -s zsh)"

      # Auto start tmux
      if [ -x "$(command -v tmux)" ] && [ -n "''${DISPLAY}" ] && [ -z "''${TMUX}" ]; then
          exec tmux new >/dev/null 2>&1
      fi
    '';
  };
}
