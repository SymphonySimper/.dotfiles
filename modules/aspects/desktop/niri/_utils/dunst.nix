{
  den.aspects.desktop.niri = {
    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        dunstctl = lib.getExe' pkgs.dunst "dunstctl";
      in
      {
        services.dunst = {
          enable = true;

          settings.global = {
            font = "${config.theme.font.sans} 12";
            origin = "top-right";
            offset = "8x8";
            frame_width = "1";
            corner_radius = "8";
          };
        };

        desktop.niri.keybinds = [
          {
            super = false;
            key = "F9";
            cmd = "${dunstctl} close";
          }
          {
            super = false;
            mod = "SHIFT";
            key = "F9";
            cmd = "${dunstctl} action";
          }
          {
            mod = "SHIFT";
            key = "F9";
            cmd = "${dunstctl} history-pop";
          }
          {
            key = "F9";
            cmd = lib.getExe (
              pkgs.writeShellScriptBin "my-dunst-toggle" # sh
                ''
                  curr_status="Unpaused"
                  msg=""
                  if [[ "$(${dunstctl} is-paused)" != "true" ]]; then
                    curr_status="Paused"
                    msg="Will be $curr_status in 5s"
                  fi

                  FXIME: support mkNotification
                  ${lib.mkNotification {
                    title = "Notfications $curr_status";
                    body = "$msg";
                    tag = "my-dunst";
                  }}

                  if [[ -n "$msg" ]]; then
                    sleep 5s
                  fi
                  ${dunstctl} set-paused toggle
                ''
            );
          }
        ];
      };
  };
}
