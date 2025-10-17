{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.scripts.ocr;

  app = lib.getExe pkgs.tesseract;
in
{
  options.my.programs.scripts.ocr.enable = lib.mkEnableOption "OCR";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "myocr"
        # sh
        ''
          lang="eng"
          if [[ -n "$2" ]]; then
            lang="$2"
          fi

          case "$1" in
            pipe) wl-paste | ${app} stdin - -l "$lang" ;;
            *) ${app} "$1" - -l "$lang" ;;
          esac
        ''
      )
    ];
  };
}
