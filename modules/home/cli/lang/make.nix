{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    gnumake
    just
  ];

  programs.helix = {
    grammars = [ "just" ];

    language = [
      {
        name = "just";
        formatter = {
          command = "${lib.getExe pkgs.just}";
          args = [ "--dump" ];
        };
      }
    ];
  };
}
