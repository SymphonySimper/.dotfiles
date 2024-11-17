{ pkgs, ... }:
{
  imports = [
    ./go.nix
    ./js.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    gcc
    gnumake
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.app-engine-go ])
  ];
}
