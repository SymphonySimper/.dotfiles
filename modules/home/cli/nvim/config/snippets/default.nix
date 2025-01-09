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
        builtins.attrNames (
          lib.attrsets.filterAttrs (
            name: value:
            let
              isNixFile = mkGetFileName name != null;
              notDefault = name != "default.nix";
              isFile = value == "regular";
            in
            isNixFile && notDefault && isFile
          ) (builtins.readDir ./.)
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
              name = if builtins.hasAttr "name" snippet then snippet.name else snippet.prefix;
              description = if builtins.hasAttr "description" snippet then snippet.description else name;
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
