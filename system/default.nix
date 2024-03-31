{ config, lib, pkgs, ... }:

{
  # Enable flakse
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11"; # Do no change

  programs.zsh.enable = true;
  user.defaultUserShell = pkgs.zsh;
}
