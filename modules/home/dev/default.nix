{ ... }: {
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
}
