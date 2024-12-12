{ pkgs, ... }:
{
  imports = [
    ./go.nix
    ./js.nix
    ./just.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
  ];

  home.packages = with pkgs; [
    gcc
    gnumake
    watchman
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.app-engine-go ])
  ];
}
