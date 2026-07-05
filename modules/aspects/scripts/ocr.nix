{ lib, ... }: {
  den.aspects.scripts.ocr = {
    homeManager =
      { pkgs, ... }:
      let
        app = lib.getExe pkgs.tesseract;
      in
      {
        home.packages = [
          (pkgs.writeShellScriptBin "myocr" ''
            lang="eng"
            if [[ -n "$2" ]]; then
              lang="$2"
            fi

            case "$1" in
              pipe) wl-paste | ${app} stdin - -l "$lang" ;;
              *) ${app} "$1" - -l "$lang" ;;
            esac
          '')
        ];
      };
  };
}
