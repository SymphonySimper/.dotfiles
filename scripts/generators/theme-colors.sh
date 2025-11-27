#!/usr/bin/env bash

colors_file="/tmp/colors.json"
output_file="./modules/flake/profiles/colors.nix"

echo "# Generated using: \`just generate-theme-colors\`" >"$output_file"

curl "https://raw.githubusercontent.com/catppuccin/palette/refs/heads/main/palette.json" |
  jq 'pick(.latte,.mocha) | map_values(.colors | map_values(.hex) | to_entries | sort_by(.key) | from_entries)' \
    >"$colors_file"

nix eval --impure --expr "builtins.fromJSON (builtins.readFile $colors_file)" >>"$output_file"
