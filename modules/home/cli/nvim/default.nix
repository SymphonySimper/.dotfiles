{ lib, my, ... }:
{
  imports = [ ./config ];

  config = lib.mkIf (my.programs.editor == "nvim") {
    programs.nixvim = {
      enable = true;
      defaultEditor = false;
      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
      withRuby = false;

      performance.byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
    };
  };
}
