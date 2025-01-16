{ lib, ... }:

let
  mkGetFileName = file: builtins.match "(.*)\.nix" file;

  files =
    builtins.map
      (
        file:
        let
          fileName = builtins.elemAt (mkGetFileName file) 0;
        in
        {
          language = fileName;
          path = "./${fileName}.json";
        }
      )
      (
        builtins.filter (name: mkGetFileName name != null && name != "default.nix") (
          lib.my.mkReadDir {
            path = ./.;
            filter = "file";
          }
        )
      );

  contents = builtins.listToAttrs (
    builtins.map (
      file:
      let
        content = builtins.listToAttrs (
          builtins.map (
            snippet:
            let
              name = lib.my.mkGetDefault snippet "name" snippet.prefix;
              description = lib.my.mkGetDefault snippet "description" name;
            in
            {
              inherit name;
              value = {
                inherit description;
                prefix = snippet.prefix;
                body = snippet.body;
              };
            }
          ) (import (./. + "/${file.language}.nix"))
        );
      in
      {
        name = "snippets/${file.language}.json";
        value = {
          text = builtins.toJSON content;
        };
      }
    ) files
  );

  packageJSON = builtins.toJSON {
    name = "my-snippets";
    contributes = {
      snippets = files;
    };
  };
in
{
  programs.nixvim.extraFiles = (
    {
      "snippets/package.json".text = packageJSON;
    }
    // contents
  );
}
