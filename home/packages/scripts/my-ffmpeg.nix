{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "my-ffmpeg" # bash
      ''
        app="${pkgs.ffmpeg}/bin/ffmpeg"

        case "$1" in
        shrink)
          shift;
          $app -i $1 -vcodec libx265 -crf 28 "$(echo $1 | cut -d '.' -f1)_shrunk.mp4"
          ;;
        to_gif)
          shift;
          $app -i $1 \
          -vf "fps=10,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
          -loop 0 "$(echo $1 | cut -d '.' -f1).gif"
          ;;
        *) echo "Unknown option" ;;
        esac
      ''
    )
  ];
}
