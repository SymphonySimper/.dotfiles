{ pkgs, lib,... }:
let
  mkNotification =
    {
      title ? throw "Title for notification cannot be empty",
      body ? "",
      tag ? "",
      progress ? "",
      urgency ? "normal", # low, normal, critical
      extraArgs ? "",
    }:
    let
      command = "${lib.getExe' pkgs.libnotify "notify-send"}";
      replaceArg = if builtins.stringLength tag > 0 then "-h string:x-dunst-stack-tag:${tag}" else "";
      progressBarArg = if builtins.stringLength progress > 0 then "-h int:value:${progress}" else "";
    in
    ''
      ${command} ${replaceArg} ${progressBarArg} -u ${urgency} "${title}" "${body}" ${extraArgs}
    '';
in
mkNotification
