{ config, ... }:
let
  paths = {
    pnpmHome = "${config.xdg.dataHome}/pnpm";
  };
  joinedPath = builtins.concatStringsSep ":" (builtins.attrValues paths);
in
{
  home = {
    # ENV
    sessionVariables = {
      EDITOR = config.my.program.editor;
      PNPM_HOME = paths.pnpmHome;
      # CONDARCA = "${config.xdg.configHome}/conda/condarc";
      MAMBA_ROOT_PREFIX = "${config.xdg.dataHome}/mamba";
      PATH = "$PATH:${joinedPath}";
      ZELLIJ_AUTO_EXIT = "true";
      #  WLR_NO_HARDWARE_CURSORS = "1";
      #  NIXOS_OZONE_WL = "1";
    };

    # Aliases
    shellAliases = {
      # general
      q = "exit";
      ka = "killall";
      ## misc
      im_light = "ps_mem -p $(pgrep -d, -u $USER)";

      # dev
      ## Nix;
      snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake";
      nix_cln = "sudo nix-collect-garbage -d; nix-collect-garbage -d;";
      nix_flake_update = "nix flake update --commit-lock-file";
      ### home-manager;
      hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake";
      ## docker
      docker_cln = "docker system prune --volumes";
    };
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = # bash
        ''
          # nix_loc="$HOME"/.nix-profile/etc/profile.d/nix.sh
          # [ -f $nix_loc ] && . $nix_loc

          . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        '';
      initExtra = # bash
        ''
          PROMPT_COMMAND="export PROMPT_COMMAND=echo"
          eval "$(micromamba shell hook -s bash)"
        '';
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autocd = true;
      defaultKeymap = "viins";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      profileExtra = # sh
        ''
          nix_loc="$HOME"/.nix-profile/etc/profile.d/nix.sh
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
              exec tmux new >/dev/null 2>&1
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
  };
}
