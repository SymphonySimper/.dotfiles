{ ... }:
let
  ignore = [

    # general
    ".DS_Store"
    "build"

    ## binary
    "**/*.exe"
    "**/*.zip"
    "**/*.parquet"
    ## media
    "**/*.png"
    "**/*.jp[e]?g"
    "**/*.web[pm]"
    ## doc
    "**/*.pdf"
    "**/*.epub"
    "**/*.odt"
    "**/*.doc[x]?"
    "**/*.calc"
    "**/*.xls[x]?"
    "**/*:Zone.Identifier"

    # js
    "node_modules"
    "vite.config.js.timestamp-*"
    "vite.config.ts.timestamp-*"
    ## svelte
    ".svelte-kit"

    # py
    ".venv"
    "venv"
    "**/__pycache__/"
  ];

  do_not_ignore = [
    # DO NOT IGNORE
    "!.github/"
    "!.gitignore"
    "!.gitattributes"
    "!.env*"
  ];
in
{
  programs.helix.ignore = builtins.concatLists [
    ignore
    do_not_ignore
  ];
}
