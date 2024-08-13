{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "notifybar" ''
      notify replace "notifybar" "NotifyBar"
    '')
  ];
}
