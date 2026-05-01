{
  my,
  inputs,
  lib,
}:
let
  formatKeys = {
    name = "%name%";
    flavor = "%flavor%";
    accent = "%accent%";
  };

  mkGetTheme =
    {
      name,
      package ? null,
      returnName ? true,
    }:
    let
      mkCapitalize =
        key: value:
        let
          capitalize = if lib.strings.hasInfix key name then false else true;
        in
        if capitalize then
          {
            key = lib.strings.toUpper key;
            value = lib.strings.toSentenceCase value;
          }
        else
          {
            inherit key value;
          };

      format = [
        (mkCapitalize formatKeys.name "catppuccin")
        (mkCapitalize formatKeys.flavor my.theme.flavor)
        (mkCapitalize formatKeys.accent my.theme.accent)
      ];

      formattedName = builtins.replaceStrings (map (f: f.key) format) (map (f: f.value) format) name;
      output =
        if package != null then
          "${inputs.catppuccin.packages.${my.system}.${package}}/${formattedName}"
        else
          formattedName;
    in
    if returnName then output else (builtins.readFile output);
in
mkGetTheme
