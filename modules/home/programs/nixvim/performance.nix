{ ... }: {
  programs.nixvim = {
    luaLoader.enable = false;

    globals = {
      loaded_tutor_mode_plugin = 1;
      loaded_matchparen = 1; # Avoid matching-bracket highlight searches on every cursor movement.

      # File management
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
      loaded_gzip = 1;
      loaded_tarPlugin = 1;
      loaded_zipPlugin = 1;
    };

    performance.byteCompileLua = {
      enable = true;
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
  };
}
