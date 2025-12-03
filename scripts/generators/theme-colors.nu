#!/usr/bin/env nu

let colors_file = "/tmp/colors.json"
let output_file = "./modules/flake/profiles/colors.nix"

"# Generated using: `just generate-theme-colors`\n" | save -f $output_file

http get "https://raw.githubusercontent.com/catppuccin/palette/refs/heads/main/palette.json"
  | select "latte" "mocha"
  | items {|name, value|
    [$name,
      ($value | get colors
        | items {|name, value| [$name, $value.hex ]} | into record | sort)] }
  | into record | save --force $colors_file

nix eval --impure --expr $"builtins.fromJSON \(builtins.readFile ($colors_file)\)" | save --append $output_file

