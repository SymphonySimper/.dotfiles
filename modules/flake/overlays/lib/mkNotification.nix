{ pkgs, lib, ... }:
let
  mkNotification =
    {
      title ? throw "Title for notification cannot be empty",
      body ? "",
      app ? null,
      urgency ? "normal", # low, normal, critical
      extraArgs ? "",
    }:
    let
      cmd = "${lib.getExe' pkgs.libnotify "notify-send"}";
      appArg = if app != null then "-app ${app}" else "";
    in
    ''
      ${cmd} ${appArg} -u ${urgency} "${title}" "${body}" ${extraArgs}
    '';
in
mkNotification
