{ config, my, ... }:
let
  customPrompt =
    # sh
    ''
      grey_bracket() {
        echo "%{%F{${my.theme.color.surface2}}%}$1%{%f%}";
      }

      bracketed_value(){
        echo "$(grey_bracket '(')%B$1%b$(grey_bracket ')')"
      }

      if [ -n "$SSH_CONNECTION" ]; then
        cs="$(bracketed_value '%{%F{${my.theme.color.green}}%}ssh%{%f%}') "
      fi

      # function to get current git branch
      get_git_branch(){
        branch_ref=$(git symbolic-ref --short HEAD 2> /dev/null)
        ref="%{%F{${my.theme.color.pink}}%}$branch_ref%{%f%}"
        [ $(echo $branch_ref |wc -w) -eq 1 ] && branch=" $(bracketed_value $ref)" || branch=""
        echo $branch
      }

      # Should be in single quotes to make re run on directory changes
      # setopt PROMPT_SUBST enable to run commands in PROMPT when enclosed with single quotes
      setopt PROMPT_SUBST
      # PROMPT='%B%F{240}%~$(get_git_branch)%f%B
      # ''${cs}>%b '

      PROMPT='%{%F{${my.theme.color.lavender}}%}%~%{%f%}$(get_git_branch)
      ''${cs}%{%F{${my.theme.color.lavender}}%}%B>%b%{%f%} '
    '';
in
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

        ${if !config.programs.starship.enable then customPrompt else ""}

        # Edit line in vim with ctrl-e:
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line
      '';
    enableCompletion = true;
    completionInit = # sh
      ''
        [[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor

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
