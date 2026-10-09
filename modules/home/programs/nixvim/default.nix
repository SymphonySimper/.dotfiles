{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./opts.nix
  ];

  programs.nixvim = {
    enable = true;
    enablePrintInit = false;

    viAlias = true;
    vimAlias = true;

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
