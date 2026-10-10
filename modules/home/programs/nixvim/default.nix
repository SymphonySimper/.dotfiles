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

    performance.byteCompileLua = {
      enable = true;
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = config.theme.flavor;
    };
  };
}
