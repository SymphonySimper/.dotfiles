{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "startup" ''
      spotify &
      foot -s &
      brightness -r & # Restore Brightness
    '')
  ];
}
