{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vm;

  res = {
    desktop = {
      width = builtins.toString (my.gui.display.width / my.gui.display.scale);
      height = builtins.toString (my.gui.display.height / my.gui.display.scale);
    };

    steam = {
      width = builtins.toString config.my.programs.steam.display.width;
      height = builtins.toString config.my.programs.steam.display.height;
    };
  };

  sudo = "/run/wrappers/bin/sudo";

  waydroidPkg = lib.getExe pkgs.waydroid;
  waydroidRestart = # sh
    "/run/current-system/sw/bin/systemctl restart waydroid-container.service";

  mkWaydroidCageLaunch =
    name: args:
    let
      waydroidLaunch = lib.getExe (
        pkgs.writeShellScriptBin "waydroid-cage-lauch"
          # sh
          ''
            ${lib.getExe pkgs.wlr-randr} --output X11-1 --custom-mode ${res.steam.width}x${res.steam.height}
            sleep 2

            ${mkWaydroidSetRes "steam"}
            ${sudo} ${waydroidRestart}
            sleep 2

            ${waydroidPkg} ${builtins.toString args}
          ''
      );
    in
    pkgs.writeShellScriptBin name # sh
      ''
        ${lib.getExe pkgs.cage} -- ${waydroidLaunch}
      '';

  mkWaydroidSetRes =
    for:
    # sh
    ''
      # ${waydroidPkg} prop set persist.waydroid.width ""
      # ${waydroidPkg} prop set persist.waydroid.height ""
      ${waydroidPkg} prop set persist.waydroid.width ${res.${for}.width}
      ${waydroidPkg} prop set persist.waydroid.height ${res.${for}.height}
    '';
in
{
  options.my.programs.vm.waydroid.enable = lib.mkEnableOption "Waydroid";

  config = lib.mkIf cfg.waydroid.enable {
    virtualisation.waydroid.enable = true;
    my.user.sudo.nopasswd = [
      waydroidRestart
    ];

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "waydroid-init" # sh
        ''
          set -e # exit on any error

          ${sudo} ${waydroidPkg} init -s GAPPS

          # controller support (Allows access to all plugged in devices)
          ${waydroidPkg} prop set persist.waydroid.udev true
          ${waydroidPkg} prop set persist.waydroid.uevent true

          # Disable freeform apps (Only fullscreen apps)
          ${waydroidPkg} prop set persist.waydroid.multi_windows false

          ${mkWaydroidSetRes "desktop"}

          ${sudo} ${waydroidRestart}

          ${waydroidPkg} show-full-ui &
          sleep 5

          # refer: https://docs.waydro.id/faq/google-play-certification
          certify_url="https://www.google.com/android/uncertified"

          android_id=$(${sudo} ${waydroidPkg} shell sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";" | ${pkgs.coreutils-full}/bin/cut -d '|' -f2)
          "${pkgs.wl-clipboard}/bin/wl-copy" "$android_id"

          echo "Android ID (copied to clipboard): $android_id"
          echo "Enter ID in this page: $certify_url"

          "${pkgs.xdg-utils}/bin/xdg-open" "$certify_url"
        ''
      )

      (mkWaydroidCageLaunch "waydroid-cage" [ "show-full-ui" ])
      (makeDesktopItem rec {
        name = "Waydroid Cage";
        desktopName = name;
        exec = "waydroid-cage";
      })

      (mkWaydroidCageLaunch "waydroid-cage-minecraft" [
        "app"
        "intent"
        "android.settings.APPLICATION_DETAILS_SETTINGS"
        "package:com.mojang.minecraftpe"
      ])
      (makeDesktopItem rec {
        name = "Waydroid Cage Minecraft";
        desktopName = name;
        exec = "waydroid-cage-minecraft";
      })
    ];
  };
}
