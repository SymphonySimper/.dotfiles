{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "startup" ''
      brightness -r & # Restore Brightness
      spotify &
      foot -s &
    '')
  ];
}
