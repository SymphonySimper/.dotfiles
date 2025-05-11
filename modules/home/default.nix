{ my, pkgs, ... }:
{
  imports = [
    ../common
    ./cli
    ./gui
  ];

  my.common.system = false;

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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (google-fonts.override { fonts = [ "Poppins" ]; })
    font-awesome
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
}
