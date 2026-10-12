{ ... }: {
  programs.nixvim = {
    luaLoader.enable = false;

    performance.byteCompileLua = {
      enable = true;
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
  };
}
