{
  den.aspects.xdg.autostart = {
    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        cfg = config.xdg.autostart;
      in
      {
        options.xdg.autostart = {
          commands = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "Name of the desktop entry";
                  };

                  command = lib.mkOption {
                    type = lib.types.str;
                    description = "Command to exec";
                  };
                };
              }
            );
            description = "Command entries to autostart on startup";
            default = [ ];
          };
        };

        config = {
          xdg = {
            autostart = {
              enable = true;
              readOnly = true;

              entries = map (
                entry:
                let
                  desktopEntry = pkgs.makeDesktopItem {
                    name = entry.name;
                    exec = entry.command;
                    desktopName = entry.name;
                  };
                in
                "${desktopEntry}/share/applications/${entry.name}.desktop"
              ) cfg.commands;
            };
          };
        };
      };
  };
}
