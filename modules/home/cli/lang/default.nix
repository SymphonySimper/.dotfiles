{ pkgs, ... }:
{
  imports = [
    ./docker.nix
    ./go.nix
    ./http.nix
    ./json.nix
    ./lua.nix
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

  programs.nixvim.plugins.lsp.servers.harper_ls.enable = true; # All
}
