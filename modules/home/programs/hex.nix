{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.hex.homeManagerModules.hex
  ];

  config = lib.mkIf config.programs.hex.enable {
    programs.hex = {
      autostart = true;

      shortcut = "F9";

      language = "en";
      installModel = true;
      model = "cohere_transcribe";

      settings = {
        "labs.unload_idle" = true;
        "labs.unload_idle_minutes" = 5;
      };
    };
  };
}
