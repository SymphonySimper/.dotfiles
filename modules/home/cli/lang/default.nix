{ pkgs, lib, ... }:
{
  imports = [
    ./go.nix
    ./js.nix
    ./just.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
  ];

  my.programs.nixpkgs-update.enable = lib.mkDefault false;

  home.packages = with pkgs; [
    gcc
    gnumake
    inotify-tools
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.app-engine-go ])
  ];
}
