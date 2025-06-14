{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.android;
in
{
  options.my.programs.android = {
    enable = lib.mkEnableOption "Android";
    vm.enable = lib.mkEnableOption "Waydroid";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      my.user.groups = [
        "kvm" # for emulators
        "adbusers"
      ];

      programs.adb.enable = true;
      services.gvfs.enable = true;

      environment.systemPackages = [
        (pkgs.android-studio.override {
          tiling_wm = config.my.programs.desktop.enable;
          forceWayland = config.my.programs.desktop.enable;
        })
      ];
    })

    (
      let
        sudo = config.my.user.sudo.exe;

        waydroid = lib.getExe pkgs.waydroid;
        actions = lib.attrsets.genAttrs [ "start" "stop" "restart" ] (
          action: "${config.my.user.bin}/systemctl ${action} waydroid-container.service"
        );

        mkSetRes =
          {
            w ? my.gui.display.string.desktop.width,
            h ? my.gui.display.string.desktop.height,
          }:
          ''
            ${waydroid} prop set persist.waydroid.width ${w}
            ${waydroid} prop set persist.waydroid.height ${h}
            ${sudo} ${actions.restart}
          '';

        extras = lib.getExe (
          pkgs.writeShellApplication {
            name = "my-waydroid-extras"; # sh

            runtimeInputs = with pkgs; [
              git
              python3Full
              # python3Packages.regex
              lzip
            ];

            text =
              let
                dir = "/tmp/waydroid_script";
                venv = ".venv";
              in
              # sh
              ''
                if [ ! -d "${dir}" ]; then
                  git clone "https://github.com/casualsnek/waydroid_script" "${dir}"
                fi

                cd "${dir}"

                if [ ! -d "${venv}" ]; then
                  python -m venv "${venv}"
                  ${venv}/bin/pip install -r requirements.txt
                fi

                ${sudo} ${venv}/bin/python main.py "''${@}"
              '';
          }
        );
      in
      lib.mkIf cfg.vm.enable {
        virtualisation.waydroid.enable = true;
        my.user.sudo.nopasswd = builtins.attrValues actions;

        environment.systemPackages = with pkgs; [
          wl-clipboard

          (writeShellScriptBin "mywaydroid" # sh
            ''
              set -e # exit on any error

              case "$1" in
                init)
                  ${sudo} ${waydroid} init

                  ${extras} ${
                    builtins.concatStringsSep " " [
                      "-a"
                      "11" # android version
                      "install"
                      "gapps"
                      "widevine"
                      (lib.strings.optionalString config.my.hardware.cpu.amd.enable "libndk")
                      (lib.strings.optionalString config.my.hardware.cpu.intel.enable "libhoudini")
                    ]
                  }

                  # controller support (Allows access to all plugged in devices)
                  ${waydroid} prop set persist.waydroid.udev true
                  ${waydroid} prop set persist.waydroid.uevent true

                  # Disable freeform apps (Only fullscreen apps)
                  ${waydroid} prop set persist.waydroid.multi_windows false

                  ${mkSetRes { }}

                  ${sudo} ${actions.restart}

                  ${waydroid} show-full-ui &
                  ${lib.getExe' coreutils "sleep"} 30

                  ${extras} certified
                  ;;

                extras)
                  shift
                  ${extras} "''${@}"
                  ;;

                # Actions
                start) ${sudo} ${actions.start} ;;
                stop) ${sudo} ${actions.stop} ;;
                restart) ${sudo} ${actions.restart} ;;

                res)
                  shift
                  case "$1" in
                    set) ${mkSetRes { }} ;;
                    reset) ${
                      mkSetRes {
                        w = "";
                        h = "";
                      }
                    } ;;
                  esac
                  ;;

                # hide desktop entries
                hide)
                  key="NoDisplay"
                  key_value="$key=true"

                  for entry in "$XDG_DATA_HOME"/applications/waydroid.*; do
                    if ${lib.getExe' gnugrep "grep"} -q "$key" "$entry"; then
                      ${lib.getExe gnused} -i "/$key/c\\$key_value" "$entry"
                    else
                      ${lib.getExe gnused} -i "/Type/a $key_value" "$entry"
                    fi
                  done
                  ;;

                clean|cln)
                  ${sudo} rm -rf ${
                    builtins.concatStringsSep " " [
                      "/var/lib/waydroid"
                      "/home/.waydroid"
                      "~/waydroid"
                      "~/.share/waydroid"
                      "~/.local/share/applications/*aydroid*"
                      "~/.local/share/waydroid"
                    ]
                  }              
                  ;;
              esac
            ''
          )
        ];
      }
    )
  ];
}
