{ inputs, config, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ./programs/default.nix
  ];

  # Do not change
  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 14d";
  };
  xdg.enable = true;
  xdg.configFile."nixpkgs/config.nix".text = # nix
    ''
      { allowUnfree = true; }
    '';

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.my.user.name;
  home.homeDirectory = config.my.directory.home.path;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = config.my.theme.flavor;
  };

  services = {
    ssh-agent.enable = true;
  };
}
