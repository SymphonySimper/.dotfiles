{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.scripts.ocr = {
    enable = lib.mkEnableOption "OCR";
  };

  config = lib.mkIf config.scripts.ocr.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "myocr" ''
        lang="eng"
        if [[ -n "$2" ]]; then
          lang="$2"
        fi

        case "$1" in
          pipe) wl-paste | ${lib.getExe pkgs.tesseract} stdin - -l "$lang" ;;
          *) ${lib.getExe pkgs.tesseract} "$1" - -l "$lang" ;;
        esac
      '')
    ];
  };
}
