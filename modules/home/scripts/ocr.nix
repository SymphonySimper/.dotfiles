{ pkgs, lib, ... }:
let
  app = lib.getExe pkgs.tesseract;
  wlpaste = lib.getExe' pkgs.wl-clipboard "wl-paste";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "myocr"
      # sh
      ''
        lang="eng"
        if [[ -n "$2" ]]; then
          lang="$2"
        fi

        case "$1" in
          pipe) ${wlpaste} | ${app} stdin - -l "$lang" ;;
          *) ${app} "$1" - -l "$lang" ;;
        esac
      ''
    )
  ];
}
