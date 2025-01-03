{ pkgs, ... }:
{
  imports = [
    ./scripts
    ./utils
    ./xdg

    ./sway.nix
  ];

  services = {
    udiskie.enable = true;
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };

  home.packages = with pkgs; [
    nautilus
  ];
}
