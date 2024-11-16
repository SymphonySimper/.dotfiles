{ config, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    profileExtra = # sh
      ''
        nix_loc="$HOME/.nix-profile/etc/profile.d/nix.sh"
        [ -f $nix_loc ] && . $nix_loc

        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      '';
    initExtra = # sh
      ''
        # Prompt
        precmd(){ precmd(){ echo ; }; }

        # Edit line in vim with ctrl-e:
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line

        eval "$(micromamba shell hook -s zsh)"

        # Auto start tmux
        if [ -x "$(command -v tmux)" ] && [ -n "''${DISPLAY}" ] && [ -z "''${TMUX}" ]; then
            exec tmux -f "${config.xdg.configHome}/tmux/tmux.conf" new >/dev/null 2>&1
        fi
      '';
    enableCompletion = true;
    completionInit = # sh
      ''
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
