{ inputs, ... }:
let
  mkPlugins =
    {
      inputs,
      prev,
      pluginsList,
    }:
    builtins.listToAttrs (
      builtins.map (name: {
        inherit name;
        value = prev.vimUtils.buildVimPlugin {
          inherit name;
          src = inputs."nvim-${name}";
        };

      }) pluginsList
    );
in

final: prev: {
  nvimPlugins = mkPlugins {
    inherit inputs;
    inherit prev;
    pluginsList =
      [
      ];
  };
}
