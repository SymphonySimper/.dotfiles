{ pkgs, ... }:
{
  my = {
    home.packages = with pkgs; [
      gnumake
      just
    ];

    programs.nvim = {
      treesitter = [
        "just"
        "make"
      ];

      formatter = {
        packages = [ "just" ];
        ft.just = "just";
      };
    };
  };
}
