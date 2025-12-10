{ my, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    ../common

    # cli
    ./dev.nix
    ./editor.nix
    ./file-manager.nix
    ./mux.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
    ./utility.nix
    ./vcs.nix
    ./work.nix

    ./scripts

    # gui
    ./browser.nix
    ./terminal.nix
    ./theme.nix

    ./desktop

    # misc
    ./copy.nix
  ];

  my.common.system = false;

  catppuccin = {
    enable = true;
    flavor = my.theme.flavor;
    accent = my.theme.accent;
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };

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
