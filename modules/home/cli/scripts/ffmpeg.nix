{ pkgs, lib, ... }:
# sh
''
  app= "${lib.getExe' pkgs.ffmpeg "ffmpeg"}"

  function get_filename() {
    echo $1 | cut -d '.' -f1
  }

  case "$1" in
  shrink)
    shift;
    $app -i $1 -vcodec libx265 -crf 28 "$(get_filename $1)_shrunk.mp4"
    ;;
  to_gif)
    shift;
    $app -i $1 \
    -vf "fps=10,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 "$(get_filename $1).gif"
    ;;
  to_webm)
    shift;

    $app -i $1 -c:v libvpx-vp9 -b:v 0 -crf 30 -c:a libopus -b:a 64k "$(get_filename $1)_webm.webm"
    ;;
  *) echo "Unknown option" ;;
  esac
''
