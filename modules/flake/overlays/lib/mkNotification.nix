{ pkgs, lib, ... }:
let
  mkNotification =
    {
      title ? throw "Title for notification cannot be empty",
      body ? "",
      app ? "notify-send",
      urgency ? "normal", # low, normal, critical
      extraArgs ? "",
    }:
    let
      appName =
        lib.trivial.throwIf (lib.strings.hasInfix " " app) "mkNotification: app cannot have [[:space:]]"
          app;
      command = "${lib.getExe' pkgs.libnotify "notify-send"}";
    in
    ''
      ${command} --app-name=${appName} --urgency=${urgency} "${title}" "${body}" ${extraArgs}
    '';
in
mkNotification
