{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "notify" ''
      case "$1" in
      replace)
        shift
        tag="$1"
        shift
        msg="$1"
        shift
        dunstify -h "string:x-dunst-stack-tag:$tag" "$msg" $@
        ;;
      *)
        msg="$1"
        shift
        dunstify "$msg" $@
        ;;
      esac
    '')
  ];
}
