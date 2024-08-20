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
        plugin:
        let
          name = "nvim-${plugin}";
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
