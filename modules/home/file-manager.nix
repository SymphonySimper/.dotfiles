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
          # fzf # quick subtree navigation (NOTE: enabled under ./utility.nix)

          # preview
          ffmpeg # video thumbnails
          poppler-utils # PDF preview
          resvg # SVG preview
          imagemagick # font, HEIC, JPEG XL preview
        ];
      };

      settings = {
        mgr.linemode = "mtime";
        preview.max_width = 1920;

        opener.edit = [
          {
            run = ''${config.my.programs.editor.command} "$@"'';
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

      keymap = {
        mgr.prepend_keymap = [
          {
            run = "plugin nucd";
            on = [ "z" ];
          }
          {
            run = "noop";
            on = [ "Z" ];
          }
        ];
      };
    };

    xdg.configFile = {
      "yazi/plugins/nucd.yazi/main.lua".text = ''
        return {
          entry = function()
            local _permit = ya.hide()

            local child, err1 = Command("nu")
                :arg({ "-l", "-c", "__my_cd_paths | input list --fuzzy" })
                :stdout(Command.PIPED)
                :stderr(Command.INHERIT)
                :spawn()

            if not child then
              return
            end

            local output, _ = child:wait_with_output()
            local target = output.stdout:gsub("\n$", "")

            if target ~= "" then
              ya.emit("cd", { target, raw = true })
            end
          end
        }
      '';
    };
  };
}
