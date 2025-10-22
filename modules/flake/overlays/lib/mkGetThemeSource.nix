{
  my,
  inputs,
  lib,
}:
let
  mkGetThemeSource =
    {
      package,
      filename,
      capitalizeFlavor ? false,
      capitalizeName ? false,
    }:
    let
      rawName = "catppuccin";
      name = if capitalizeName then lib.strings.toSentenceCase rawName else rawName;
      flavor = if capitalizeFlavor then lib.strings.toSentenceCase my.theme.flavor else my.theme.flavor;

      formattedFileName = builtins.replaceStrings [ "NAME" "FLAVOR" ] [ name flavor ] filename;
    in
    (builtins.readFile "${inputs.catppuccin.packages.${my.system}.${package}}/${formattedFileName}");
in
mkGetThemeSource
