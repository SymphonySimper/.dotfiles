{ userSettings, ... }: {
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

      ${if userSettings.programs.wm then ''
      [ "$(tty)" = "/dev/tty1" ] && exec .sway-wrapped
      '' else ""}
    '';
    initExtra = ''
      # Prompt
      precmd(){ precmd(){ echo ; }; }

      # Edit line in vim with ctrl-e:
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line

      eval "$(micromamba shell hook -s zsh)"

      ${if userSettings.programs.zellij then "" else 
      ''
            # Auto start tmux
            if [ -x "$(command -v tmux)" ] && [ -n "''${DISPLAY}" ] && [ -z "''${TMUX}" ]; then
                exec tmux new >/dev/null 2>&1
            fi
            ''
      }
    '';
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit && compinit -u
      zstyle ':completion:*' menu select
      # Auto complete with case insenstivity
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)	
    '';
  };
}
