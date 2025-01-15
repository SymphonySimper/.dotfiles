{
  my,
  ...
}:
{
  imports = [
    ./font.nix

    ../common
    ./cli
    ./gui
  ];

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

    stateVersion = "23.11"; # Do not change
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
