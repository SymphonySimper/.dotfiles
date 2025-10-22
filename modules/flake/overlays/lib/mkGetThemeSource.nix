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
      capitalize ? false,
      capitalizeFlavor ? null,
      capitalizeName ? null,
      capitalizeAccent ? null,
    }:
    let
      mkCapitalize =
        conditionValue: value:
        let
          condition = if conditionValue == null then capitalize else conditionValue;
        in
        if condition then lib.strings.toSentenceCase value else value;

      name = mkCapitalize capitalizeName "catppuccin";
      flavor = mkCapitalize capitalizeFlavor my.theme.flavor;
      accent = mkCapitalize capitalizeAccent my.theme.accent;

      formattedFileName =
        builtins.replaceStrings [ "NAME" "FLAVOR" "ACCENT" ] [ name flavor accent ]
          filename;
    in
    (builtins.readFile "${inputs.catppuccin.packages.${my.system}.${package}}/${formattedFileName}");
in
mkGetThemeSource
