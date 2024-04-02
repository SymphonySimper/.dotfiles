{ userSettings, ... }:
{
  imports = [
    ./packages/cli/default.nix
    ./packages/dev/default.nix
    ./packages/editor/default.nix
    ./packages/shell/default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  # Do not change
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
