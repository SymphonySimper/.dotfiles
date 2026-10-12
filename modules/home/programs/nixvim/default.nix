{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./plugins

    ./keymaps.nix
    ./lsp.nix
    ./opts.nix
    ./performance.nix
  ];

  programs.nixvim = {
    enable = true;
    enablePrintInit = false;

    defaultEditor = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = lib.mkForce false;
    withPerl = lib.mkForce false;
    withPython3 = lib.mkForce false;
    withRuby = lib.mkForce false;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = config.theme.flavor;
    };
  };
}
