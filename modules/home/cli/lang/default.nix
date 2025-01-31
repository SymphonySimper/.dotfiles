{ pkgs, ... }:
{
  imports = [
    ./docker.nix
    ./http.nix
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
