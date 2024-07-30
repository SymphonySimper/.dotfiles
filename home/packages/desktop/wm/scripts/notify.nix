{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "notify" ''
      app="${pkgs.libnotify}/bin/notify-send"

      case "$1" in
      replace)
        shift
        tag="$1"
        shift
        msg="$1"
        shift
        $app -h "string:x-dunst-stack-tag:$tag" "$msg" $@
        ;;
      *)
        msg="$1"
        shift
        $app "$msg" $@
        ;;
      esac
    '')
  ];
}
