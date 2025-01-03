{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnumake
    just
  ];

  programs.nixvim.plugins = {
    treesitter.grammars = [
      "make"
      "just"
    ];

    conform-nvim = {
      formatter.just = pkgs.just;
      settings.formatters_by_ft.just = [ "just" ];
    };
  };
}
