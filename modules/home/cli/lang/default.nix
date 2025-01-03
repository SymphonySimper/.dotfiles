{ pkgs, lib, ... }:
{
  imports = [
    ./docker.nix
    ./go.nix
    ./http.nix
    ./lua.nix
    ./make.nix
    ./markdown.nix
    ./markup.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./sh.nix
    ./web.nix
  ];

  my.programs.nixpkgs-update.enable = lib.mkDefault false;

  home.packages = with pkgs; [
    gcc
    inotify-tools
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.app-engine-go ])
  ];
}
