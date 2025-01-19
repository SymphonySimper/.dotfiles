{ my, ... }:
{
  services.dunst = {
    enable = if my.programs.notification == "dunst" then true else false;
    settings.global = {
      font = "${my.theme.font.sans} 12";
      origin = "top-right";
      offset = "8x8";
      frame_width = "1";
      corner_radius = "8";
    };
  };
}
