{ pkgs, ... }:
{
  imports = [
    ./docker.nix
    ./json.nix
    ./make.nix
    ./markdown.nix
    ./markup.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./web.nix
  ];

  home.packages = with pkgs; [
    gcc
    inotify-tools
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.app-engine-go ])
  ];
}
