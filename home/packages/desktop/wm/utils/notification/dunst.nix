{ userSettings, ... }:
{
  services.dunst = {
    enable = if userSettings.programs.notification == "dunst" then true else false;
    settings = {
      global = {
        font = "${userSettings.font.sans} 12";
        origin = "top-right";
        offset = "8x8";
        frame_width = "1";
        corner_radius = "8";
        highlight = userSettings.theme.color.lavender;
      };
    };
  };
}
