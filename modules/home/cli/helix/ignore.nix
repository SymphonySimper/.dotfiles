{ ... }:
let
  ignore = [
    # general
    ".DS_Store"
    "build"

    # binary
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
  ];

  do_not_ignore = [
    "!.github/"
    "!.env*"
  ];
in
{
  programs.helix.ignore = builtins.concatLists [
    ignore
    do_not_ignore
  ];
}
