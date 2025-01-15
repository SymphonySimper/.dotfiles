{ pkgs, ... }:
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
}
