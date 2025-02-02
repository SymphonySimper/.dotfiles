{ pkgs, lib, ... }:
{
  programs.helix = {
    grammars = [
      "toml"
      "yaml"
    ];

    language = [
      {
        name = "toml";
        formatter = {
          command = "${lib.getExe pkgs.taplo}";
          args = [
            "format"
            "-"
          ];
        };
      }
      {
        name = "yaml";
        formatter = {
          command = "${lib.getExe pkgs.nodePackages.prettier}";
          args = [
            "--parser"
            "yaml"
          ];
        };
      }
    ];
  };
}
