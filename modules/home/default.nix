{ my, ... }:
{
  imports = [
    ../common

    # cli
    ./dev.nix
    ./direnv.nix
    ./editor.nix
    ./fonts.nix
    ./mux.nix
    ./nix.nix
    ./ssh.nix
    ./utility.nix
    ./vcs.nix
    ./wsl.nix
    ./yazi.nix

    ./scripts
    ./shell

    # gui
    ./browser.nix
    ./terminal.nix
    ./theme.nix

    ./desktop
  ];

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
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
