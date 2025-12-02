$env.EDITOR = 'hx'
$env.LS_COLORS = ''
$env.VISUAL = 'hx'


if not ($nu.cache-dir | path exists) {
  mkdir $nu.cache-dir
}

if not ("$"($nu.cache-dir)/carapace.nu"" | path exists) {
  carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace.nu"
}

if not ("$"($nu.cache-dir)/zoxide.nu"" | path exists) {
  zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"
}

if not ("$"($nu.cache-dir)/starship.nu"" | path exists) {
  starship init nu | save -f $"($nu.cache-dir)/starship.nu"
}
