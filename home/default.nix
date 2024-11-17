{ inputs, my, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ./packages/cli/default.nix
    ./packages/dev/default.nix
    ./packages/nvim/default.nix
    ./packages/scripts/default.nix
    ./packages/shell/default.nix
    (import ../modules/common/nix.nix {
      inherit inputs;
      system = false;
    })
  ];

  nixpkgs.config.allowUnfree = true;

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

  services = {
    ssh-agent.enable = true;
  };
}
