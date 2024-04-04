{ pkgs, ... }:
{
  imports = [
    ./js.nix
    ./python.nix
    ./rust.nix
  ];

  home.packages = with pkgs; [
    gcc
    gnumake
    google-cloud-sdk
  ];
}
