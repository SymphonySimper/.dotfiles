{ pkgs, lib, ... }:
{
  packages = with pkgs; [
    (
      let
        open = lib.getExe' pkgs.xdg-utils "xdg-open";
        mkDate =
          last:
          "$(${lib.getExe' pkgs.coreutils "date"} -d '${lib.strings.optionalString last "last "}saturday' +%Y-%m-%d)";
      in
      writeShellScriptBin "my-flake-update-commits" # sh
        ''
          last_saturday="${mkDate true}"
          saturday="${mkDate false}"

          ${lib.strings.concatLines (
            builtins.map (x: ''${open} "${x}/?since=''${last_saturday}&until=''${saturday}"'') [
              "https://github.com/catppuccin/nix/commits/main"
              "https://github.com/helix-editor/helix/commits/master"
              "https://github.com/nix-community/home-manager/commits/master"
              "https://github.com/nix-community/NixOS-WSL/commits/main"
            ]
          )}
        ''
    )
  ];
}
