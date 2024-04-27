{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      # nix_loc="$HOME"/.nix-profile/etc/profile.d/nix.sh
      # [ -f $nix_loc ] && . $nix_loc

      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
    initExtra = ''
      PROMPT_COMMAND="export PROMPT_COMMAND=echo"
      eval "$(micromamba shell hook -s bash)"
    '';
  };
}
