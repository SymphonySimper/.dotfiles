{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.yazi;
in
{
  options.my.programs.yazi = {
    enable = lib.mkEnableOption "Enable Yazi";
  }
  // (lib.my.mkCommandOption {
    category = "File Manager";
    command = lib.getExe config.programs.yazi.package;
  });

  config = lib.mkIf cfg.enable {
    my.programs = {
      desktop.keybinds = [
        {
          key = "e";
          mods = [ "super" ];
          command = "${config.my.programs.terminal.command} ${config.my.programs.terminal.args.command} ${cfg.command}";
        }
      ];

      mux.keybinds = [
        {
          key = "y";
          command = cfg.command;
          currentPath = true;
        }
      ];
    };

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      package = pkgs.yazi.override {
        optionalDeps = with pkgs; [
          _7zz # archive extraction
          fd # file searching

          # preview
          ffmpeg # video thumbnails
          imagemagick # font, HEIC, JPEG XL preview
          poppler-utils # PDF preview
          resvg # SVG preview
        ];
      };

      settings = {
        mgr.linemode = "mtime";
        preview.max_width = 1920;

        opener.edit = [
          {
            run = "${config.my.programs.editor.command} %s";
            block = true;
          }
        ];

        open.prepend_rules = [
          {
            mime = "{audio,video}/*";
            use = [
              "open"
              "reveal"
            ];
          }
        ];
      };
    };
  };
}
