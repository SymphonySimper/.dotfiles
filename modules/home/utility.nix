{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        bc # calculator
        killall

        # web
        curl
        wget
      ];
    }

    {
      programs.man = {
        enable = true;
        generateCaches = true;

      };

      home.packages = [
        pkgs.tlrc # tldr
      ];
    }

    {
      programs = {
        fzf = {
          enable = true;
          defaultOptions = [
            "--reverse"
          ];
        };

        fd.enable = true;
        jq.enable = true;
        ripgrep.enable = true;
      };
    }

    # Clipboard
    {
      home.packages = [ pkgs.wl-clipboard ];
    }

    (lib.mkIf config.my.programs.desktop.enable {
      services.cliphist.enable = true;

      xdg.configFile."cliphist/config".text = ''
        db-path /tmp/my-${my.name}-clip/db
      '';

      my.programs =
        let
          size = "80%";

          script = lib.getExe (
            let
              app = lib.getExe' config.services.cliphist.package "cliphist";
              sort = lib.getExe' pkgs.coreutils "sort";

              preview = lib.getExe (
                pkgs.writeShellScriptBin "myclip-preview" ''
                  # show preview if non-binary data
                  echo "$1" | ${lib.getExe' pkgs.gnugrep "grep"} -q '[\[ binary data .* \]\]' || echo "$1" | ${app} decode                  
                ''
              );
            in
            pkgs.writeShellScriptBin "myclip" ''
              to_copy=$(
                ${app} list |
                  ${sort} -k 2 -u | # sort by 2 field to the end of line and output only unique lines
                  ${sort} -nr | # sort numerically in reverse
                  ${lib.getExe' pkgs.fzf "fzf"} --preview "${preview} {}"
              )

              if [ -n "$to_copy" ]; then
                echo "$to_copy" | ${app} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
              fi
            ''
          );
        in
        {
          mux.keybinds = [
            {
              key = "v";
              action = "display-popup";
              args = [
                "-E"
                "-w ${size}"
                "-h ${size}"
                script
              ];
            }
          ];

          desktop =
            let
              class = "myclip";
            in
            {
              windows = [
                {
                  id = class;
                  state = [
                    "float"
                    "center"
                    {
                      name = "size";
                      opts = [
                        size
                        size
                      ];
                    }
                  ];
                }
              ];

              keybinds = [
                {
                  key = "v";
                  cmd =
                    let
                      cfgT = config.my.programs.terminal;
                      cfgS = config.my.programs.shell;
                    in
                    builtins.concatStringsSep " " [
                      cfgT.exe

                      cfgT.args.class
                      class

                      cfgT.args.cmd
                      cfgS.exe
                      cfgS.args.login
                      cfgS.args.cmd
                      script
                    ];
                }
              ];
            };
        };
    })
  ];
}
