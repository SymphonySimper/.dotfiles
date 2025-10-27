{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.terminal;
  cfgSh = config.my.programs.shell;
  cfgM = config.my.programs.mux;

  terminalFiles = {
    unix = "unix.toml";
    winGen = "windows-gen.toml";
    win = "windows.toml";
  };

  mkProgramKeyBind =
    {
      key,
      mods,
      cli ? true,
      program,
      args ? [ ],
    }:
    {
      inherit key mods;
      command = {
        program = if cli then cfg.command else program;
        args =
          if cli then
            [
              cfg.args.command
              cfgSh.command
              cfgSh.args.login
              cfgSh.args.command
              (lib.strings.escapeShellArgs ([ program ] ++ args))
            ]
          else
            args;
      };
    };
in
{
  options.my.programs.terminal =
    (lib.my.mkCommandOption {
      category = "Terminal";
      command = "alacritty";
      args = {
        command = "-e";
        class = "--class";
      };
    })
    // {
      shell = {
        command = lib.mkOption {
          description = "Default command to run on launch";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
    };

  config = lib.mkIf my.gui.enable {
    my.programs = {
      desktop = {
        autostart = [ cfg.command ];

        windows = [
          {
            id = "Alacritty";
            workspace = 1;
          }
        ];
      };

      copy.of =
        let
          winDir = "WINDOWS/${cfg.command}";
        in
        [
          {
            from = "CONFIG/${cfg.command}/";
            to = "${winDir}/";
            exclude = [ terminalFiles.unix ];
            post = # sh
              ''
                mv "${winDir}/${terminalFiles.winGen}" "${winDir}/${terminalFiles.win}"
              '';
          }
        ];
    };

    catppuccin.alacritty.enable = false;

    xdg.configFile =
      let
        formatToml = pkgs.formats.toml { };
      in
      {
        "${cfg.command}/${terminalFiles.unix}".source = (
          formatToml.generate terminalFiles.unix {
            terminal.shell = {
              program = cfgSh.command;
              args = [
                cfgSh.args.login
              ]
              ++ (lib.lists.optionals (cfg.shell.command != null) [
                cfgSh.args.command
                cfg.shell.command
              ]);
            };

            keyboard.bindings = [
              (mkProgramKeyBind {
                key = "T";
                mods = "Alt|Shift";
                cli = true;
                program = cfgM.command;
                args = [ cfgM.args.new ];
              })
            ];
          }
        );

        "${cfg.command}/${terminalFiles.winGen}".source =
          let
            wsl = {
              command = "wsl";
              args = [
                "-d"
                "NixOS"
                "--cd"
                "~"
                "--shell-type"
                "login"
              ];
              mux = [
                "--"
                cfgM.command
                cfgM.args.new
              ];
            };
          in
          (formatToml.generate terminalFiles.winGen {
            window.startup_mode = "Maximized";

            terminal.shell = {
              # program = "pwsh";
              # args = ["-WorkingDirectory" "~"];
              program = wsl.command;
              args = wsl.args;
            };

            keyboard.bindings = [
              {
                key = "T";
                mods = "Alt|Shift";
                command = {
                  program = cfg.command;
                  args = builtins.concatLists [
                    [
                      cfg.args.command
                      wsl.command
                    ]
                    wsl.args
                    wsl.mux
                  ];
                };
              }
            ];
          });
      };

    programs.alacritty = {
      enable = true;

      settings = {
        general = {
          import = [
            "./${terminalFiles.unix}"
            "./${terminalFiles.win}"
          ];

          live_config_reload = false;
          ipc_socket = false;
        };

        window = {
          decorations = "none";
          opacity = 1;
          # startup_mode = "Maximized";
          padding = rec {
            x = 2;
            y = x;
          };
          dynamic_padding = true;
        };

        scrolling.history = 1000;
        selection.save_to_clipboard = true;

        font = {
          size = 12;
          normal = {
            family = my.theme.font.mono;
            style = "Regular";
          };
          bold = {
            family = my.theme.font.mono;
            style = "Bold";
          };
          italic = {
            family = my.theme.font.mono;
            style = "Italic";
          };
          bold_italic = {
            family = my.theme.font.mono;
            style = "Bold Italic";
          };
        };

        cursor = {
          vi_mode_style = "Block";
          style = {
            blinking = "off";
            shape = "Block";
          };
        };

        mouse.hide_when_typing = true;

        # comment out below line to disable hints
        # hints.enabled = [ ];

        keyboard.bindings = [
          {
            key = "V";
            mods = "Alt";
            action = "ToggleViMode";
          }
          {
            key = "T";
            mods = "Alt";
            action = "CreateNewWindow";
          }
          {
            key = "M";
            mods = "Alt";
            action = "ToggleMaximized";
          }
          {
            key = "F";
            mods = "Alt|Shift";
            action = "ToggleFullscreen";
          }
        ];

        colors =
          (builtins.fromTOML (
            lib.my.mkGetThemeSource {
              package = cfg.command;
              filename = "NAME-FLAVOR.toml";
            }
          )).colors;
      };
    };
  };
}
