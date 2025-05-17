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
    })

    (
      let
        sudo = "/run/wrappers/bin/sudo";

        waydroidPkg = lib.getExe pkgs.waydroid;
        waydroidRestart = # sh
          "${config.my.user.bin}/systemctl restart waydroid-container.service";

        mkWaydroidSetRes =
          {
            w ? my.gui.display.string.desktop.width,
            h ? my.gui.display.string.desktop.height,
          }:
          ''
            ${waydroidPkg} prop set persist.waydroid.width ${w}
            ${waydroidPkg} prop set persist.waydroid.height ${h}
            ${sudo} ${waydroidRestart}
          '';
      in
      lib.mkIf cfg.vm.enable {
        virtualisation.waydroid.enable = true;
        my.user.sudo.nopasswd = [
          waydroidRestart
        ];

        environment.systemPackages = with pkgs; [
          wl-clipboard
          python3Packages.pyclip

          (writeShellScriptBin "waydroid-init" # sh
            ''
              set -e # exit on any error

              ${sudo} ${waydroidPkg} init -s GAPPS

              # controller support (Allows access to all plugged in devices)
              ${waydroidPkg} prop set persist.waydroid.udev true
              ${waydroidPkg} prop set persist.waydroid.uevent true

              # Disable freeform apps (Only fullscreen apps)
              ${waydroidPkg} prop set persist.waydroid.multi_windows false

              ${mkWaydroidSetRes { }}

              ${sudo} ${waydroidRestart}

              ${waydroidPkg} show-full-ui &
              sleep 5

              # refer: https://docs.waydro.id/faq/google-play-certification
              certify_url="https://www.google.com/android/uncertified"

              android_id=$(${sudo} ${waydroidPkg} shell sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";" | ${lib.getExe' pkgs.coreutils-full "cut"} -d '|' -f2)
              "${lib.getExe' pkgs.wl-clipboard "wl-copy"}" "$android_id"

              echo "Android ID (copied to clipboard): $android_id"
              echo "Enter ID in this page: $certify_url"

              "${lib.getExe' pkgs.xdg-utils "xdg-open"}" "$certify_url"
            ''
          )

          (writeShellScriptBin "waydroid-reset-res" (mkWaydroidSetRes {
            w = "";
            h = "";
          }))
          (writeShellScriptBin "waydroid-set-res" (mkWaydroidSetRes { }))
        ];
      }
    )
  ];
}
