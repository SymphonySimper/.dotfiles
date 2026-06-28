{ helpers, ... }:
builtins.listToAttrs (
  map
    (dir: {
      name = dir;
      value = {
        path = ./. + "/${dir}";
        description = "${dir} template";
      };
    })
    (
      helpers.mkReadDir {
        dirPath = ./.;
        type = "dir";
      }
    )
)
