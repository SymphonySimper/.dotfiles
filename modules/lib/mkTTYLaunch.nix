{ pkgs, ... }:
let
  mkTTYLaunch =
    {
      command,
      tty ? 1,
      dbus ? false,
    }:
    let
      dbusCmd = if dbus then "${pkgs.dbus}/bin/dbus-run-session" else "";
    in
    # bash
    ''[[ "$(tty)" = "/dev/tty${builtins.toString tty}" ]] && exec ${dbusCmd} ${command}'';
in
mkTTYLaunch
