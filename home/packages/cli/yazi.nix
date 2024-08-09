{ inputs, pkgs, ... }:
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
          1
          3
          4
        ];
      };
      preview = {
        max_height = 1920;
        max_width = 1080;
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
