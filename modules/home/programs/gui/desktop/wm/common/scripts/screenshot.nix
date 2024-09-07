{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "screenshot" ''
      loc="$HOME/Pictures/Screenshots"
      take_screenshot() { ${pkgs.hyprshot}/bin/hyprshot -m $1 -o $loc; }

      case "$1" in
      -r) take_screenshot region ;;
      -w) take_screenshot window ;;
      -s) take_screenshot output ;;
      esac
    '')
  ];
}
