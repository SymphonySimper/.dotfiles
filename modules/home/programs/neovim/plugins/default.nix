{ lib, ... }: {
  imports = [
    ./lsp.nix
    ./tree-sitter.nix
  ];

  programs.neovim = {
    withNodeJs = lib.mkForce false;
    withPerl = lib.mkForce false;
    withRuby = lib.mkForce false;
    withPython3 = lib.mkForce false;
  };
}
