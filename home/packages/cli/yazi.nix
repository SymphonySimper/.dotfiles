{
  inputs,
  pkgs,
  userSettings,
  ...
}:
{
  programs.yazi = {
    enable = true;
    # package = inputs.yazi.packages.${pkgs.system}.default;
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        ratio = [
          1 # left
          3 # center
          4 # right
        ];
      };
      preview = {
        max_height = 1920;
        max_width = 1080;
        ueberzug_scale = 1.5;
        ueberzug_offset = [
          (-28.0) # x
          (0.0) # y
          (0.0) # w
          (0.0) # h
        ];
      };
      opener = {
        edit = [
          {
            run = ''${userSettings.programs.editor} "$@"'';
            block = true;
            for = "unix";
          }
        ];
        play = [
          {
            run = ''${userSettings.programs.video} "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = ''xdg-open "$@"'';
            desc = "Open";
          }
        ];
      };
    };
    plugins = {
      max-preview = "${inputs.yazi-plugins}/max-preview.yazi/";
    };
    keymap = {
      manager.prepend_keymap = [
        {
          on = "T";
          run = "plugin --sync max-preview";
          desc = "Maximize or restore preview";
        }
      ];
    };
  };

  home.packages = [ pkgs.ueberzugpp ];
}
