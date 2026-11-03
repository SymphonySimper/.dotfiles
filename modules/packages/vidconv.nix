{
  ffmpeg,
  writeShellApplication,
}:

writeShellApplication {
  name = "vidconv";
  runtimeInputs = [ ffmpeg ];
  text = ''
    usage() {
      echo "Usage: vidconv {shrink|to_gif|to_webm} <file>" >&2
      exit 1
    }

    [[ $# -eq 2 ]] || usage
    input="$2"
    name="''${input%.*}"

    case "$1" in
    shrink)
      ffmpeg -i "$input" -vcodec libx265 -crf 28 "''${name}_shrunk.mp4"
      ;;
    to_gif)
      ffmpeg -i "$input" \
        -vf "fps=10,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
        -loop 0 "$name.gif"
      ;;
    to_webm)
      ffmpeg -i "$input" -c:v libvpx-vp9 -b:v 0 -crf 30 -c:a libopus -b:a 64k "''${name}_webm.webm"
      ;;
    *) usage ;;
    esac
  '';
}
