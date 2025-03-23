{ pkgs, lib, ... }:
let
  sites = import ./bookmarks.nix;
in
{
  imports = [
    ./chromium.nix
  ];

  xdg.desktopEntries = builtins.listToAttrs (
    builtins.map (
      entry:
      let
        name = builtins.elemAt entry 0;
        _url = builtins.elemAt entry 1;
        url = if lib.strings.hasPrefix "http" _url then _url else "https://${_url}";

        scriptName = builtins.concatStringsSep "-" (lib.strings.splitString " " (lib.strings.toLower name));
        execScript = lib.getExe (
          pkgs.writeShellScriptBin scriptName # sh
            ''
              ${lib.getExe' pkgs.xdg-utils "xdg-open"} ${url}                
            ''
        );
      in
      {
        inherit name;
        type = "entry";
        value = {
          inherit name;
          type = "Application";
          genericName = name;
          comment = "Launch ${name}";
          categories = [ "Application" ];
          terminal = false;
          exec = execScript;
          settings = {
            StartupWMClass = name;
          };
        };
      }
    ) (builtins.concatLists (builtins.attrValues sites))
  );
}
