#!/usr/bin/env nu

if ($nu.os-info.name != "windows") {
  print "Can only be ran on windows!."
  exit 1
}
 
const source_dir = "config\\windows"
let home_dir = $env.USERPROFILE
let config_dir = $env.APPDATA
let local_dir = $env.LOCALAPPDATA

def get-source-folder-name [dir: string]  {
  $"($source_dir)\\($dir)"
}


let exclude_sources = [] | each {|dir| get-source-folder-name $dir}

let destinations = {
  wsl: $home_dir,
  starship: $"($home_dir)\\.config",
  terminal: (ls $"($local_dir)\\packages" | where name has "Microsoft.WindowsTerminal_" | first | $"($in.name)\\LocalState"),
  PowerToys: $"($local_dir)\\Microsoft\\PowerToys",
  yazi: $"($config_dir)\\yazi\\config"
}

ls $source_dir
| where name not-in $exclude_sources
| each {|dir|
    {
      source: $"($dir.name)/*",
      destination: (
        $destinations
        | get --optional ($dir.name | path basename)
        | default ($dir.name | str replace $source_dir $config_dir)
      )
    }
  }
| each {|dir|
  if not ($dir.destination | path exists) {
    mkdir $dir.destination
  }

  cp --recursive --verbose ($dir.source | into glob) $dir.destination
}
