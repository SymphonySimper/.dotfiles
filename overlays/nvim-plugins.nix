{ inputs, ... }:
let
  mkPlugins =
    {
      inputs,
      prev,
      pluginsList,
    }:
    builtins.listToAttrs (
      builtins.map (
        n:
        let
          name = "nvim-${n}";
        in
        {
          inherit name;
          value = prev.vimUtils.buildVimPlugin {
            inherit name;
            src = inputs.${name};
          };

        }
      ) pluginsList
    );
in

final: prev: {
  vimPlugins =
    prev.vimPlugins
    // mkPlugins {
      inherit inputs;
      inherit prev;
      pluginsList = [ "markview" ];
    };
}
