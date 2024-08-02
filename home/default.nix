{
  inputs,
  userSettings,
  profileSettings,
  ...
}:
let
  enableServices =
    if profileSettings.profile == "gui" && userSettings.programs.wm == false then false else true;
in
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ./packages/cli/default.nix
    ./packages/dev/default.nix
    ./packages/editor/default.nix
    ./packages/scripts/default.nix
    ./packages/shell/default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;
  xdg.configFile."nixpkgs/config.nix".text = # nix
    ''
      { allowUnfree = true; }
    '';

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = userSettings.home;

  # Do not change
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  services = {
    gnome-keyring.enable = enableServices;
    ssh-agent.enable = enableServices;
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 14d";
  };
}
