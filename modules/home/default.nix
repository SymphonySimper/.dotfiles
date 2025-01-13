{
  my,
  config,
  lib,
  ...
}:
{
  imports = [
    ./font.nix

    ../common
    ./cli
    ./gui
  ];

  options.my.home.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    description = "Packages to be installed in home";
    default = [ ];
  };

  config = {
    my.common.system = false;

    xdg = {
      enable = true;
      configFile."nixpkgs/config.nix".text = # nix
        ''
          { allowUnfree = true; }
        '';
    };

    home = {
      username = my.name;
      homeDirectory = my.dir.home;
      packages = config.my.home.packages;

      stateVersion = "23.11"; # Do not change
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
