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
    ./sh.nix
    ./web.nix
  ];

  my = {
    home.packages = with pkgs; [
      gcc
      inotify-tools
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.app-engine-go ])
    ];

    programs.nvim.lsp.harper_ls.enable = true; # All
  };
}
