$env.EDITOR = 'hx'
$env.FZF_DEFAULT_OPTS = '--reverse --color bg:#eff1f5,bg+:#ccd0da,fg:#4c4f69,fg+:#4c4f69,header:#8839ef,hl:#8839ef,hl+:#8839ef,info:#8839ef,marker:#8839ef,pointer:#8839ef,prompt:#8839ef,spinner:#dc8a78'
$env.LS_COLORS = ''
$env.STARSHIP_LOG = 'error'
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
