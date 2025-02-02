{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    gnumake
    just
  ];

  programs.nixvim.plugins = {
    treesitter.grammars = [
      "just"
      "make"
    ];

    formatter = {
      packages = [ "just" ];
      ft.just = "just";
    };
  };

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
