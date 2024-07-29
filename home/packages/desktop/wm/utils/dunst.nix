{ userSettings, ... }:
let
  colors = (import ../../../../../assets/colors.nix).mocha;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "${userSettings.font.sans} 12";
        origin = "top-right";
        offset = "8x8";
        frame_width = "1";
        corner_radius = "8";
        highlight = colors.lavender;
      };
    };
  };
}