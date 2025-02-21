{ helpers, ... }:
builtins.listToAttrs (
  builtins.map
    (dir: {
      name = dir;
      value = {
        path = ./. + "/${dir}";
        description = "${dir} template";
      };
    })
    (
      helpers.mkReadDir {
        path = ./.;
        type = "dir";
      }
    )
)
