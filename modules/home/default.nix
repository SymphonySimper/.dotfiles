{ inputs, my, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ./cli
    ./font.nix
    ./gui
    (import ../common/nix.nix {
      inherit inputs;
      system = false;
    })
  ];

  xdg.enable = true;
  xdg.configFile."nixpkgs/config.nix".text = # nix
    ''
      { allowUnfree = true; }
    '';

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = my.name;
  home.homeDirectory = my.dir.home;

  # Do not change
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = my.theme.flavor;
  };

}
