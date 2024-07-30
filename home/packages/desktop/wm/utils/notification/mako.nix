{ userSettings, ... }:
{
  services.mako = {
    enable = if userSettings.programs.notification == "mako" then true else false;
    actions = true;
    markup = true;
    anchor = "top-right";
    font = "${userSettings.font.sans} 12";
    defaultTimeout = 3000;
    borderRadius = 8;
    borderSize = 1;
    maxIconSize = 32;
    padding = "4";
  };
}
