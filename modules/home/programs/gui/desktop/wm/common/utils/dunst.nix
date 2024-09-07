{ config, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "${config.my.theme.font.sans.name} 12";
        origin = "top-right";
        offset = "8x8";
        frame_width = "1";
        corner_radius = "8";
        highlight = config.my.theme.color.lavender;
      };
    };
  };
}
