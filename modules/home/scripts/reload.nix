{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.scripts.reload;

  commands = builtins.map (
    command:
    let
      append = ''my_commands+=("${command.name}")'';

      check =
        if command.value.check != null then
          # sh
          ''
            if command -v ${command.value.check} >/dev/null 2>&1; then
              ${command.value.command}
              ${append}
            fi
          ''
        else
          ''
            ${command.value.command}
            ${append}
          '';
    in
    # sh
    ''
      ${check}
    ''
  ) (lib.attrsets.attrsToList cfg.commands);

  reload =
    pkgs.writeShellScriptBin "myreload" # sh
      ''
        my_commands=()

        ${lib.strings.concatLines commands}

        reloaded_cmds=""
        for name in "''${my_commands[@]}"; do
            reloaded_cmds+="<span>- ''${name}</span>\n"
        done

        ${lib.strings.optionalString my.gui.enable (
          lib.my.mkNotification {
            tag = "myreload";
            title = "Restarted";
            body = "$reloaded_cmds";
          }
        )}
      '';
in
{
  options.my.programs.scripts.reload = {
    enable = lib.mkEnableOption "Reload";

    commands = lib.mkOption {
      description = "Commands to include in reload";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to restart";
            };

            check = lib.mkOption {
              type = lib.types.str;
              description = "Check to run if the command exists";
              default = null;
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    my.programs = {
      scripts.reload.commands = {
        "Network Manager" = {
          command = "sudo systemctl restart NetworkManager";
          check = "NetworkManager";
        };
      };

      desktop.keybinds = [
        {
          mod = "SHIFT";
          key = "F5";
          command = lib.getExe reload;
        }
      ];
    };

    home.packages = [ reload ];
  };
}
