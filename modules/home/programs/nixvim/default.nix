{ inputs, lib, ... }: {
  imports = [
    inputs.nixvim.homeModules.nixvim
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
  };
}
