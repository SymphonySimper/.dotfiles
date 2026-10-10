{ config, lib, ... }: {
  imports = [
    ./keymaps.nix
    ./options.nix

    ./plugins/conform.nix
    ./plugins/fzf.nix
    ./plugins/lsp.nix
    ./plugins/mini.nix
    ./plugins/tree-sitter.nix
  ];

  programs.neovim = {
    enable = true;
    # defaultEditor = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    waylandSupport = config.desktop.enable;

    withNodeJs = lib.mkForce false;
    withPerl = lib.mkForce false;
    withRuby = lib.mkForce false;
    withPython3 = lib.mkForce false;
  };
}
