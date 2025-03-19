{ pkgs, lib, ... }:
{
  programs = {
    jq.enable = true;

    helix.language =
      builtins.map
        (name: {
          inherit name;
          formatter = {
            command = "${lib.getExe pkgs.nodePackages.prettier}";
            args = [
              "--parser"
              name
            ];
          };
        })
        [
          "json"
          "jsonc"
        ];
  };
}
