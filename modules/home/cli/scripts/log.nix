{
  my,
  pkgs,
  lib,
  ...
}:
let
  repo = "git@github.com:SymphonySimper/log.git";
  loc = "${my.dir.data}/log";
  readlink = lib.getExe' pkgs.coreutils-full "readlink";
  ln = lib.getExe' pkgs.coreutils-full "ln";
in
# bash
''
  if [[ ! -d "${loc}" ]]; then
    echo "Cloning repo to ${loc}"
    ${lib.getExe pkgs.git} clone "${repo}" "${loc}"
  fi

  cd "${loc}" || exit 1

  current_day="$(date '+%d-%m-%Y')"
  today_file="''${current_day}.md"
  today_link="today.md"

  if [[ ! -f  "$today_file" ]]; then
    touch "$today_file"
  fi

  function link_file() {
      ${ln} -sf "$today_file" "$today_link"
  }

  if [[ -f "$today_link" ]]; then
    if [[  "$(${readlink} $today_link)" != "$today_file" ]]; then
      link_file
    fi
  else
    link_file
  fi

  $EDITOR "$today_link"
''
