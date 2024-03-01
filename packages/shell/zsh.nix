{ config, pkgs, ... }:
let
  aliases = import ./aliases.nix;
in
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    autocd = true;
    defaultKeymap = "viins";
    shellAliases = aliases.shellAliases;
    profileExtra = ''
      nix_loc="$HOME"/.nix-profile/etc/profile.d/nix.sh
      [ -f $nix_loc ] && . $nix_loc

      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
    initExtra = ''

      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/home/symph/.local/share/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/home/symph/.local/share/miniconda3/etc/profile.d/conda.sh" ]; then
              . "/home/symph/.local/share/miniconda3/etc/profile.d/conda.sh"
          else
              export PATH="/home/symph/.local/share/miniconda3/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<
    '';
  };
}
