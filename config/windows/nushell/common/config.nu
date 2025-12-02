source $"($nu.default-config-dir)/common/theme.nu"
 
$env.config.show_banner = false

$env.config.buffer_editor = "hx"

$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true

$env.config.completions.algorithm = "fuzzy"
$env.config.completions.external.max_results = 20

$env.config.datetime_format.normal = "%d/%m/%y %I:%M:%S%p"

$env.config.filesize.unit = "metric"
$env.config.filesize.show_unit = true

source $"($nu.cache-dir)/carapace.nu"
source $"($nu.cache-dir)/starship.nu"
def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

source $"($nu.cache-dir)/zoxide.nu"