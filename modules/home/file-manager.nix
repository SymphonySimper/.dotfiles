{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.file-manager;
in
{
  options.my.programs.file-manager = lib.my.mkCommandOption {
    category = "File Manager";
    command = "yazi";
  };

  config = {
    my.programs = {
      desktop.keybinds = [
        {
          key = "e";
          mods = [ "super" ];
          command = "${config.my.programs.terminal.command} ${config.my.programs.terminal.args.command} ${cfg.command}";
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
          chafa
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
            run = ''${config.my.programs.editor.command} %s'';
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
