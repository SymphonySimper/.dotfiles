{ pkgs, lib, ... }: {
  imports = [
    ./android.nix
    ./docker.nix
    ./go.nix
    ./harper.nix
    ./json.nix
    ./markdown.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./toml.nix
    ./tree-sitter.nix
    ./web.nix
    ./yaml.nix
  ];

  _module.args = {
    mkPrettier = name: {
      command = lib.getExe pkgs.prettier;
      args = [
        "--parser"
        name
      ];
    };

    mkVscodeLsp = lang: rec {
      name = "vscode-${lang}-language-server";
      command = lib.getExe' pkgs.vscode-langservers-extracted name;
    };
  };
}
