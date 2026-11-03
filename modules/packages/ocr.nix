{
  tesseract,
  wl-clipboard,
  writeShellApplication,
}:

writeShellApplication {
  name = "ocr";
  runtimeInputs = [
    tesseract
    wl-clipboard
  ];
  text = ''
    if [[ $# -lt 1 ]]; then
      echo "Usage: ocr {pipe|<image>} [lang]" >&2
      exit 1
    fi

    lang="''${2:-eng}"

    case "$1" in
    pipe) wl-paste | tesseract stdin - -l "$lang" ;;
    *) tesseract "$1" - -l "$lang" ;;
    esac
  '';
}
