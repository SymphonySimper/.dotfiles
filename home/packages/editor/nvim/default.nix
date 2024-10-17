{ lib, userSettings, ... }:
{
  imports = [ ./config ];

  config = lib.mkIf (userSettings.programs.editor == "nvim") {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
      withRuby = false;

      performance = {
        byteCompileLua = {
          enable = true;
          nvimRuntime = true;
          configs = true;
          plugins = true;
        };
      };
    };
  };
}
